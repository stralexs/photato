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
        let viewModel: Login.SignIn.ViewModel
        switch response.signInResult {
        case let error as FirebaseError:
            viewModel = Login.SignIn.ViewModel(signInErrorDescription: error.errorDescription)
        case let error as KeychainError:
            viewModel = Login.SignIn.ViewModel(signInErrorDescription: error.errorDescription)
        default:
            viewModel = Login.SignIn.ViewModel(signInErrorDescription: nil)
        }
        
        viewController?.displaySignInResult(viewModel: viewModel)
    }
    
    func presentLocationsDownloadCompletion(response: Login.DownloadLocations.Response) {
        let viewModel: Login.DownloadLocations.ViewModel
        switch response.downloadResult {
        case let error as FirebaseError:
            viewModel = Login.DownloadLocations.ViewModel(downloadErrorDescription: error.errorDescription)
        default:
            viewModel = Login.DownloadLocations.ViewModel(downloadErrorDescription: nil)
        }
        
        viewController?.displayLocationsDownloadResult(viewModel: viewModel)
    }
}
