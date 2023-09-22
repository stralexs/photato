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
            let isEmailTextFieldValid: Bool
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
            let isPasswordTextFieldValid: Bool
        }
    }
    
    enum SignIn {
        struct Request {
            let email: String
            let password: String
        }
        
        struct Response {
            let isSignInSuccessful: Bool
        }
        
        struct ViewModel {
            let isSignInSuccessful: Bool
        }
    }
}
