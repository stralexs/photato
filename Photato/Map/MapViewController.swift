//
//  MapViewController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import MapKit
import SnapKit

protocol MapDisplayLogic: AnyObject {
    func displayLocationServicesStatus(viewModel: Map.CheckLocationServicesEnabled.ViewModel)
    func displayAuthorizationStatus(viewModel: Map.CheckAuthorizationStatus.ViewModel)
    func displayLocations(viewModel: Map.GetLocationsAnnotations.ViewModel)
}

class MapViewController: UIViewController, MapDisplayLogic {
    // MARK: - Properties
    var interactor: MapBusinessLogic?
    var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tuneUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServicesEnabled()
        getLocationsAnnotations()
    }
    
    // MARK: - Methods
    func checkLocationServicesEnabled() {
        let request = Map.CheckLocationServicesEnabled.Request()
        interactor?.checkLocationServicesEnabled(request: request)
    }
    
    func displayLocationServicesStatus(viewModel: Map.CheckLocationServicesEnabled.ViewModel) {
        let isLocationServicesEnabled = viewModel.isLocationServicesEnabled
        if isLocationServicesEnabled {
            setupLocationManager()
            checkAthorizationStatus()
        } else {
            showAlertAction(title: "Включите Службы геолокации, чтобы позволить \"Photato\" определять ваше местоположение", message: nil)
        }
    }
    
    func setupLocationManager() {
        let request = Map.SetupLocationManager.Request()
        interactor?.setupLocationManager(request: request)
    }
    
    func checkAthorizationStatus() {
        let request = Map.CheckAuthorizationStatus.Request()
        interactor?.checkAuthorizationStatus(request: request)
    }
    
    func displayAuthorizationStatus(viewModel: Map.CheckAuthorizationStatus.ViewModel) {
        guard let authorizationStatus = viewModel.locationAuthorizationStatus else { return }
        if authorizationStatus {
            mapView.showsUserLocation = true
        } else {
            showAlertAction(title: "Вы запретили использование местоположения", message: "Хотите это изменить?")
        }
    }
    
    func getLocationsAnnotations() {
        let request = Map.GetLocationsAnnotations.Request()
        interactor?.fetchLocations(request: request)
    }
    
    func displayLocations(viewModel: Map.GetLocationsAnnotations.ViewModel) {
        viewModel.annotations.forEach { annotation in
            mapView.addAnnotation(annotation)
        }
    }
    
    func tuneUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        mapView.delegate = self
    }
    
    private func showAlertAction(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func configure() {
        let viewController = self
        let interactor = MapInteractor(worker: MapWorker(locationManagerDelegate: viewController))
        let presenter = MapPresenter()
        let router = MapRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAthorizationStatus()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            let markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            markerAnnotationView.glyphImage = UIImage(systemName: "camera")
            markerAnnotationView.markerTintColor = .tortilla
            
            annotationView = markerAnnotationView
            
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            let image = UIImage(systemName: "info.circle.fill")
            button.setImage(image, for: .normal)
            button.tintColor = .darkOliveGreen
            annotationView?.rightCalloutAccessoryView = button
        } else {
            let markerAnnotationView = MKMarkerAnnotationView()
            markerAnnotationView.glyphImage = UIImage(systemName: "camera")
            markerAnnotationView.markerTintColor = .tortilla
            
            annotationView = markerAnnotationView
            annotationView?.annotation = annotation
        }
                
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let locationName = view.annotation?.title else { return }
        router?.routeToLocationDescription(with: locationName)
    }
}
