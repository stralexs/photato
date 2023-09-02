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
}

class MapPresenter: MapPresentationLogic {
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
        var locationsAnnotations: [MKAnnotation] = []
        
        response.locations.forEach { location in
            let annotation = MKPointAnnotation()
            annotation.title = location.name
            annotation.subtitle = location.address
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
            annotation.coordinate = coordinate
            locationsAnnotations.append(annotation)
        }
        
        let viewModel = Map.GetLocationsAnnotations.ViewModel(annotations: locationsAnnotations)
        viewController?.displayLocations(viewModel: viewModel)
    }
}
