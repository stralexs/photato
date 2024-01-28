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
            let locatinsDownloadResult: Result<[Location], FirebaseError>
        }
        
        struct ViewModel {
            let locationsDownloadDescription: ([Location]?, String?)
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
    
    enum RefreshLocations {
        struct Requst {}
        
        struct Response {
            let locationsRefreshResult: Result<[Location], FirebaseError>
        }
        
        struct ViewModel {
            let locationsRefreshDescription: ([Location]?, String?)
        }
    }
}
