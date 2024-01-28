//
//  MapDisplayLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 2.09.23.
//

import MapKit
@testable import Photato

final class MapDisplayLogicSpy: MapDisplayLogic {
    private(set) var isCalledDisplayLocationServicesStatus = false
    private(set) var isCalledDisplayAuthorizationStatus = false
    private(set) var isCalledDisplayLocations = false
    var mapView: MKMapView = MKMapView()
    
    func displayLocationServicesStatus(viewModel: Photato.Map.CheckLocationServicesEnabled.ViewModel) {
        isCalledDisplayLocationServicesStatus = true
    }
    
    func displayAuthorizationStatus(viewModel: Photato.Map.CheckAuthorizationStatus.ViewModel) {
        isCalledDisplayAuthorizationStatus = true
    }
    
    func displayLocations(viewModel: Photato.Map.GetLocationsAnnotations.ViewModel) {
        isCalledDisplayLocations = true
        
        viewModel.annotationsDownloadDescription.forEach { annotation in
            mapView.addAnnotation(annotation)
        }
    }
}
