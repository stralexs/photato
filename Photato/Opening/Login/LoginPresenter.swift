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
}

final class LoginPresenter: LoginPresentationLogic {
    weak var viewController: LoginDisplayLogic?
    
    func presentEmailTextFieldValidation(response: Login.ValidateEmailTextField.Response) {
        let viewModel = Login.ValidateEmailTextField.ViewModel(isEmailTextFieldValid: response.isEmailTextFieldValid)
        viewController?.displayEmailTextFieldValidation(viewModel: viewModel)
    }
    
    func presentPasswordTextFieldValidation(response: Login.ValidatePasswordTextField.Response) {
        let viewModel = Login.ValidatePasswordTextField.ViewModel(isPasswordTextFieldValid: response.isPasswordTextFieldValid)
        viewController?.displayPasswordTextFieldValidation(viewModel: viewModel)
    }
}
