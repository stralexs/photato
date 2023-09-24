//
//  LoadingModels.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit

enum Loading {
    enum SignInUser {
        struct Request {}
        
        struct Response {
            let signInResult: Error?
        }
        
        struct ViewModel {
            let signInErrorDescription: String?
        }
    }
    
    enum DownloadLocations {
        struct Request {}
        
        struct Response {
            let downloadResult: Error?
        }
        
        struct ViewModel {
            let downloadErrorDescription: String?
        }
    }
}
