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
}
