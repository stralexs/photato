//
//  ProfileModels.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

enum Profile {
    enum GetUserFavouriteLocations {
        struct Request {}
        
        struct Response {
            let locations: [Location]
        }
        
        struct ViewModel {
            let locations: [Location]
        }
    }
    
    enum FetchUserData {
        struct Request {}
        
        struct Response {
            let name: String
            let imageData: Data
        }
        
        struct ViewModel {
            let name: String
            let image: UIImage
        }
    }
}
