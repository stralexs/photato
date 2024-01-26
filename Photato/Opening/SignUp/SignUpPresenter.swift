//
//  SignUpPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

protocol SignUpPresentationLogic {
    func presentNameTextFieldValidation(response: SignUp.ValidateNameTextField.Response)
    func presentEmailTextFieldValidation(response: SignUp.ValidateEmailTextField.Response)
    func presentPasswordTextFieldValidation(response: SignUp.ValidatePasswordTextField.Response)
    func presentSignUpResult(response: SignUp.SignUp.Response)
    func presentLocationsDownloadCompletion(response: SignUp.DownloadLocations.Response)
}

final class SignUpPresenter: SignUpPresentationLogic {
    weak var viewController: SignUpDisplayLogic?
    
    func presentNameTextFieldValidation(response: SignUp.ValidateNameTextField.Response) {
        var nameTextFieldValidationDescription: String?
        if response.isNameTextFieldValid == false {
            nameTextFieldValidationDescription = "Please fill name field"
        }
        
        let viewModel = SignUp.ValidateNameTextField.ViewModel(nameTextFieldValidationDescription: nameTextFieldValidationDescription)
        viewController?.displayNameTextFieldValidation(viewModel: viewModel)
    }
    
    func presentEmailTextFieldValidation(response: SignUp.ValidateEmailTextField.Response) {
        var emailTextFieldValidationDescription: String?
        if response.isEmailTextFieldValid == false {
            emailTextFieldValidationDescription = "Invalid Email. Example: photo123@gmail.com"
        }
        
        let viewModel = SignUp.ValidateEmailTextField.ViewModel(emailTextFieldValidationDescription: emailTextFieldValidationDescription)
        viewController?.displayEmailTextFieldValidation(viewModel: viewModel)
    }
    
    func presentPasswordTextFieldValidation(response: SignUp.ValidatePasswordTextField.Response) {
        var passwordTextFieldValidationDescription: String?
        if response.isPasswordTextFieldValid == false {
            passwordTextFieldValidationDescription = "Password must contain at least 6 characters"
        }
        
        let viewModel = SignUp.ValidatePasswordTextField.ViewModel(passwordTextFieldValidationDescription: passwordTextFieldValidationDescription)
        viewController?.displayPasswordTextFieldValidation(viewModel: viewModel)
    }
    
    func presentSignUpResult(response: SignUp.SignUp.Response) {
        let viewModel: SignUp.SignUp.ViewModel
        switch response.signUpResult {
        case let error as FirebaseError:
            viewModel = SignUp.SignUp.ViewModel(signUpErrorDescription: error.errorDescription)
        default:
            viewModel = SignUp.SignUp.ViewModel(signUpErrorDescription: nil)
        }
        
        viewController?.displaySignUpResult(viewModel: viewModel)
    }
    
    func presentLocationsDownloadCompletion(response: SignUp.DownloadLocations.Response) {
        let viewModel: SignUp.DownloadLocations.ViewModel
        switch response.downloadResult {
        case let error as FirebaseError:
            viewModel = SignUp.DownloadLocations.ViewModel(downloadErrorDescription: error.errorDescription)
        default:
            viewModel = SignUp.DownloadLocations.ViewModel(downloadErrorDescription: nil)
        }
        
        viewController?.displayLocationsDownloadResult(viewModel: viewModel)
    }
}
