//
//  MapBusinessLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 2.09.23.
//

import Foundation
@testable import Photato

final class MapBusinessLogicSpy: MapBusinessLogic {
    private(set) var isCalledCheckLocationServicesEnabled = false
    private(set) var isCalledSetupLocationManager = false
    private(set) var isCalledCheckAuthorizationStatus = false
    private(set) var isCalledFetchLocations = false
    
    func checkLocationServicesEnabled(request: Photato.Map.CheckLocationServicesEnabled.Request) {
        isCalledCheckLocationServicesEnabled = true
    }
    
    func setupLocationManager(request: Photato.Map.GetUserLocation.Request) {
        isCalledSetupLocationManager = true
    }
    
    func checkAuthorizationStatus(request: Photato.Map.CheckAuthorizationStatus.Request) {
        isCalledCheckAuthorizationStatus = true
    }
    
    func fetchLocations(request: Photato.Map.GetLocationsAnnotations.Request) {
        isCalledFetchLocations = true
    }
}
