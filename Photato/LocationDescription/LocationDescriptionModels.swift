//
//  LocationDescriptionModels.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

enum LocationDescription {    
    enum ShowLocationDescription {
        struct Request {}
        
        struct Response {
            let location: Location
        }
        
        struct ViewModel {
            struct DisplayedLocation {
                let name: String
                let description: String
                let address: String
                let coordinates: String
                let imagesData: [Data]
            }
            
            let displayedLocation: DisplayedLocation
        }
    }
    
    enum CopyCoordinatesToClipboard {
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {}
    }
    
    enum OpenLocationInMaps {
        struct Request {}
    }
}
