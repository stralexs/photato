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
            let location: Location
            let stringLocationCoordinates: String
        }
    }
    
    enum GetLocationImagesCount {
        struct Request {}
        
        struct Response {
            let imagesCount: Int
        }
        
        struct ViewModel {
            let imagesCount: Int
        }
    }
    
    enum GetLocationAllImages {
        struct Request {}
        
        struct Response {
            let imagesData: [Data]
        }
        
        struct ViewModel {
            let imagesData: [Data]
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
