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
    
    func tuneUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
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
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAthorizationStatus()
    }
}
