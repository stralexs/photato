//
//  LocationsListModels.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

enum LocationsList {
    enum FetchLocations {
        struct Request {}
        
        struct Response {
            let locations: [Location]
        }
        
        struct ViewModel {
            let locations: [Location]
        }
    }
    
    enum SearchLocations {
        struct Request {
            let searchText: String
        }
        
        struct Response {
            let locations: [Location]
        }
        
        struct ViewModel {
            let locations: [Location]
        }
    }
}
