//
//  LoginModels.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

enum Login {    
    enum ValidateEmailTextField {
        struct Request {
            let emailTextFieldText: String?
        }
        
        struct Response {
            let isEmailTextFieldValid: Bool
        }
        
        struct ViewModel {
            let emailTextFieldValidationDescription: String?
        }
    }
    
    enum ValidatePasswordTextField {
        struct Request {
            let passwordTextFieldText: String?
        }
        
        struct Response {
            let isPasswordTextFieldValid: Bool
        }
        
        struct ViewModel {
            let passwordTextFieldValidationDescription: String?
        }
    }
    
    enum SignIn {
        struct Request {
            let email: String
            let password: String
        }
        
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
