//
//  MapPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import MapKit

protocol MapPresentationLogic {
    func presentLocationServicesStatus(response: Map.CheckLocationServicesEnabled.Response)
    func presentAuthorizationStatus(response: Map.CheckAuthorizationStatus.Response)
    func presentLocationsAnnotations(response: Map.GetLocationsAnnotations.Response)
    func presentRefreshedLocationsAnnotations(response: Map.RefreshLocations.Response)
}

final class MapPresenter: MapPresentationLogic {
    weak var viewController: MapDisplayLogic?
        
    func presentLocationServicesStatus(response: Map.CheckLocationServicesEnabled.Response) {
        let isLocationServicesEnabled = response.isLocationServicesEnabled
        let viewModel = Map.CheckLocationServicesEnabled.ViewModel(isLocationServicesEnabled: isLocationServicesEnabled)
        viewController?.displayLocationServicesStatus(viewModel: viewModel)
    }
    
    func presentAuthorizationStatus(response: Map.CheckAuthorizationStatus.Response) {
        let authorizationStatus = response.locationAuthorizationStatus
        let viewModel = Map.CheckAuthorizationStatus.ViewModel(locationAuthorizationStatus: authorizationStatus)
        viewController?.displayAuthorizationStatus(viewModel: viewModel)
    }
    
    func presentLocationsAnnotations(response: Map.GetLocationsAnnotations.Response) {
        let viewModel: Map.GetLocationsAnnotations.ViewModel
        switch response.locationsDownloadResult {
        case .success(let locations):
            let locationsAnnotations = locations.map { location in
                let annotation = MKPointAnnotation()
                annotation.title = location.name
                annotation.subtitle = location.address
                let coordinate = CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
                annotation.coordinate = coordinate
                return annotation
            }
            viewModel = Map.GetLocationsAnnotations.ViewModel(annotationsDownloadDescription: (locationsAnnotations, nil))
        case .failure(let error):
            viewModel = Map.GetLocationsAnnotations.ViewModel(annotationsDownloadDescription: (nil, error.errorDescription))
        }
        viewController?.displayLocations(viewModel: viewModel)
    }
    
    func presentRefreshedLocationsAnnotations(response: Map.RefreshLocations.Response) {
        let viewModel: Map.RefreshLocations.ViewModel
        switch response.locationsDownloadResult {
        case .success(let locations):
            let locationsAnnotations = locations.map { location in
                let annotation = MKPointAnnotation()
                annotation.title = location.name
                annotation.subtitle = location.address
                let coordinate = CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
                annotation.coordinate = coordinate
                return annotation
            }
            viewModel = Map.RefreshLocations.ViewModel(annotationsDownloadDescription: (locationsAnnotations, nil))
        case .failure(let error):
            viewModel = Map.RefreshLocations.ViewModel(annotationsDownloadDescription: (nil, error.errorDescription))
        }
        viewController?.displayRefreshedLocations(viewModel: viewModel)
    }
}
