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
        let viewModel = SignUp.ValidateNameTextField.ViewModel(isNameTextFieldValid: response.isNameTextFieldValid)
        viewController?.displayNameTextFieldValidation(viewModel: viewModel)
    }
    
    func presentEmailTextFieldValidation(response: SignUp.ValidateEmailTextField.Response) {
        let viewModel = SignUp.ValidateEmailTextField.ViewModel(isEmailTextFieldValid: response.isEmailTextFieldValid)
        viewController?.displayEmailTextFieldValidation(viewModel: viewModel)
    }
    
    func presentPasswordTextFieldValidation(response: SignUp.ValidatePasswordTextField.Response) {
        let viewModel = SignUp.ValidatePasswordTextField.ViewModel(isPasswordTextFieldValid: response.isPasswordTextFieldValid)
        viewController?.displayPasswordTextFieldValidation(viewModel: viewModel)
    }
    
    func presentSignUpResult(response: SignUp.SignUp.Response) {
        var viewModel = SignUp.SignUp.ViewModel(signUpErrorDescription: nil)
        
        switch response.signUpResult {
        case nil:
            break
        case let error as FirebaseError:
            switch error {
            case .signUpError:
                viewModel = SignUp.SignUp.ViewModel(signUpErrorDescription: "Failed to sign up. Please try again later")
            case .occupiedEmail:
                viewModel = SignUp.SignUp.ViewModel(signUpErrorDescription: "The email address is already in use by another account. Pleasy try another one")
            default:
                viewModel = SignUp.SignUp.ViewModel(signUpErrorDescription: "Unknown error")
            }
        default:
            break
        }
        
        viewController?.displaySignUpResult(viewModel: viewModel)
    }
    
    func presentLocationsDownloadCompletion(response: SignUp.DownloadLocations.Response) {
        var viewModel = SignUp.DownloadLocations.ViewModel(downloadErrorDescription: nil)
        
        switch response.downloadResult {
        case nil:
            break
        case let error as FirebaseError:
            switch error {
            case .locationsNotLoadedError:
                viewModel = SignUp.DownloadLocations.ViewModel(downloadErrorDescription: "Failed to load locations. Please try again later")
            case .downloadImageDataError:
                viewModel = SignUp.DownloadLocations.ViewModel(downloadErrorDescription: "Failed to load data. Please try again later")
            default:
                viewModel = SignUp.DownloadLocations.ViewModel(downloadErrorDescription: "Unknown error")
            }
        default:
            break
        }
        
        viewController?.displayLocationsDownloadResult(viewModel: viewModel)
    }
}
