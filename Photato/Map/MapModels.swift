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
    
    enum GetUserLocation {
        struct Request {}
        
        struct Response {
            let location: CLLocation
        }
        
        struct ViewModel {
            let region: MKCoordinateRegion
        }
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
            let locationsDownloadResult: Result<[Location], FirebaseError>
        }
        
        struct ViewModel {
            let annotationsDownloadDescription: ([MKAnnotation]?, String?)
        }
    }
    
    enum RefreshLocations {
        struct Request {}
        
        struct Response {
            let locationsDownloadResult: Result<[Location], FirebaseError>
        }
        
        struct ViewModel {
            let annotationsDownloadDescription: ([MKAnnotation]?, String?)
        }
    }
}
