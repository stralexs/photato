//
//  SettingsModels.swift
//  Photato
//
//  Created by Alexander Sivko on 27.09.23.
//

import UIKit

enum Settings {
    enum GetUserData {
        struct Request {}
        
        struct Response {
            let user: User
        }
        
        struct ViewModel {
            let userData: (name: String, profilePicture: Data)
        }
    }
    
    enum ValidateNameTextField {
        struct Request {
            let nameTextFieldText: String?
        }
        
        struct Response {
            let isNameTextFieldValid: Bool
        }
        
        struct ViewModel {
            let nameTextFieldValidationDescription: String?
        }
    }
    
    enum ApplyChanges {
        struct Request {
            let name: String
            let profilePicture: UIImage
        }
        
        struct Response {
            let applyChangesResult: Error?
        }
        
        struct ViewModel {
            let applyChangesErrorDescription: String?
        }
    }
    
    enum LeaveAccount {
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {}
    }
}
