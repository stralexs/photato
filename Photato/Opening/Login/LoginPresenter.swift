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
    
    func presentSignInResult(response: Login.SignIn.Response) {
        let viewModel = Login.SignIn.ViewModel(isSignInSuccessful: response.isSignInSuccessful)
        viewController?.displaySignInResult(viewModel: viewModel)
    }
}
