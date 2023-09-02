//
//  MapModels.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import MapKit

enum Map {
    enum CheckLocationServicesEnabled {
        struct Request {}
        
        struct Response {
            let isLocationServicesEnabled: Bool
        }
        
        struct ViewModel {
            let isLocationServicesEnabled: Bool
        }
    }
    
    enum SetupLocationManager {
        struct Request {}
    }
    
    enum CheckAuthorizationStatus {
        struct Request {}
        
        struct Response {
            let locationAuthorizationStatus: Bool?
        }
        
        struct ViewModel {
            let locationAuthorizationStatus: Bool?
        }
    }
    
    enum GetLocationsAnnotations {
        struct Request {}
        
        struct Response {
            let locations: [Location]
        }
        
        struct ViewModel {
            let annotations: [MKAnnotation]
        }
    }
}
