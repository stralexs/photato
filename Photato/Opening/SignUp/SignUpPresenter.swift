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
}
