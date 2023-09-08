//
//  MapWorker.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import MapKit

protocol MapWorkingLogic {
    var locationManager: CLLocationManager { get }
    func checkLocationServicesStatus() -> Bool
    func setupLocationManager()
    func checkAuthorizationStatus() -> Bool?
    func fetchLocations(completion: @escaping ([Location]) -> Void)
}

class MapWorker: NSObject, MapWorkingLogic {
    let locationManager: CLLocationManager = CLLocationManager()
    
    func checkLocationServicesStatus() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkAuthorizationStatus() -> Bool? {
        var authorizationStatus: Bool?
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            authorizationStatus = true
            break
        case .restricted:
            break
        case .denied:
            authorizationStatus = false
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
        return authorizationStatus
    }
    
    func fetchLocations(completion: @escaping ([Location]) -> Void) {
        LocationsManager.shared.downloadLocations { downloadedLocations in
            completion(downloadedLocations)
        }
    }
    
    init(locationManagerDelegate: CLLocationManagerDelegate) {
        self.locationManager.delegate = locationManagerDelegate
    }
}
