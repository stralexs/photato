//
//  LocationsListModels.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

enum LocationsList {
    enum FetchLocations {
        struct Request {
            var searchText: String
        }
        
        struct Response {
            var locations: [Location]
        }
        
        struct ViewModel {
            struct DisplayedLocation {
                var name: String
                var address: String
                var imageData: Data
            }
            
            var displayedLocations: [DisplayedLocation]
        }
    }
}
