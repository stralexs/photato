//
//  LoginPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

protocol LoginPresentationLogic {
    func presentEmailTextFieldValidation(response: Login.ValidateEmailTextField.Response)
    func presentPasswordTextFieldValidation(response: Login.ValidatePasswordTextField.Response)
    func presentSignInResult(response: Login.SignIn.Response)
    func presentLocationsDownloadCompletion(response: Login.DownloadLocations.Response)
}

final class LoginPresenter: LoginPresentationLogic {
    weak var viewController: LoginDisplayLogic?
    
    func presentEmailTextFieldValidation(response: Login.ValidateEmailTextField.Response) {
        var emailTextFieldValidationDescription: String?
        if response.isEmailTextFieldValid == false {
            emailTextFieldValidationDescription = "Invalid Email. Example: photo123@gmail.com"
        }
        
        let viewModel = Login.ValidateEmailTextField.ViewModel(emailTextFieldValidationDescription: emailTextFieldValidationDescription)
        viewController?.displayEmailTextFieldValidation(viewModel: viewModel)
    }
    
    func presentPasswordTextFieldValidation(response: Login.ValidatePasswordTextField.Response) {
        var passwordTextFieldValidationDescription: String?
        if response.isPasswordTextFieldValid == false {
            passwordTextFieldValidationDescription = "Password must contain at least 6 characters"
        }
        
        let viewModel = Login.ValidatePasswordTextField.ViewModel(passwordTextFieldValidationDescription: passwordTextFieldValidationDescription)
        viewController?.displayPasswordTextFieldValidation(viewModel: viewModel)
    }
    
    func presentSignInResult(response: Login.SignIn.Response) {
        var viewModel = Login.SignIn.ViewModel(signInErrorDescription: nil)
        
        switch response.signInResult {
        case nil:
            break
        case let error as FirebaseError:
            switch error {
            case .failedToSignIn:
                viewModel = Login.SignIn.ViewModel(signInErrorDescription: "Failed to sign in. Check your credentials")
            case .failedToGetUserData:
                viewModel = Login.SignIn.ViewModel(signInErrorDescription: "Failed to get your data. Please try again later")
            default:
                viewModel = Login.SignIn.ViewModel(signInErrorDescription: "Unknown error")
            }
        default:
            break
        }
        
        viewController?.displaySignInResult(viewModel: viewModel)
    }
    
    func presentLocationsDownloadCompletion(response: Login.DownloadLocations.Response) {
        var viewModel = Login.DownloadLocations.ViewModel(downloadErrorDescription: nil)
        
        switch response.downloadResult {
        case nil:
            break
        case let error as FirebaseError:
            switch error {
            case .dataNotLoaded:
                viewModel = Login.DownloadLocations.ViewModel(downloadErrorDescription: "Failed to load locations. Please try again later")
            case .imageDataNotLoaded:
                viewModel = Login.DownloadLocations.ViewModel(downloadErrorDescription: "Failed to load data. Please try again later")
            default:
                viewModel = Login.DownloadLocations.ViewModel(downloadErrorDescription: "Unknown error")
            }
        default:
            break
        }
        
        viewController?.displayLocationsDownloadResult(viewModel: viewModel)
    }
}
