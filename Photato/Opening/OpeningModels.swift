//
//  OpeningModels.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

enum Opening {
    enum CheckIsUserLoggedIn {
        struct Request {}
        
        struct Response {
            let isUserLoggedIn: Bool
        }
        
        struct ViewModel {
            let isUserLoggedIn: Bool
        }
    }
}
