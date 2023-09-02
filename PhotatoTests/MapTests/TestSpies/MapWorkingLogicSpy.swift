//
//  MapWorkingLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 2.09.23.
//

import CoreLocation
@testable import Photato

final class MapWorkingLogicSpy: MapWorkingLogic {
    var locationManager: CLLocationManager = CLLocationManager()
    
    private(set) var isCalledCheckLocationServicesStatus = false
    private(set) var isCalledSetupLocationManager = false
    private(set) var isCalledCheckAuthorizationStatus = false
    private(set) var isCalledFetchLocations = false
    
    func checkLocationServicesStatus() -> Bool {
        isCalledCheckLocationServicesStatus = true
        return true
    }
    
    func setupLocationManager() {
        isCalledSetupLocationManager = true
    }
    
    func checkAuthorizationStatus() -> Bool? {
        isCalledCheckAuthorizationStatus = true
        return nil
    }
    
    func fetchLocations() -> [Photato.Location] {
        isCalledFetchLocations = true
        return []
    }
}

