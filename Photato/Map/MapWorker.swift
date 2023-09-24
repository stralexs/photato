//
//  MapWorker.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import MapKit

protocol MapWorkingLogic {
    func checkLocationServicesStatus(completion: @escaping (Bool) -> Void)
    func setupLocationManager()
    func checkAuthorizationStatus() -> Bool?
}

final class MapWorker: NSObject, MapWorkingLogic {
    private let locationManager: CLLocationManager = CLLocationManager()
    
    func checkLocationServicesStatus(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            completion(CLLocationManager.locationServicesEnabled())
        }
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
    
    init(locationManagerDelegate: CLLocationManagerDelegate) {
        self.locationManager.delegate = locationManagerDelegate
    }
}
