//
//  LoginInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

protocol LoginBusinessLogic {
    func validateEmailTextField(request: Login.ValidateEmailTextField.Request)
    func validatePasswordTextField(request: Login.ValidatePasswordTextField.Request)
    func signIn(request: Login.SignIn.Request)
}

protocol LoginDataStore {}

final class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    var presenter: LoginPresentationLogic?
    var worker: LoginWorker?
    private let firebaseManager: FirebaseAuthenticationLogic
    
    func validateEmailTextField(request: Login.ValidateEmailTextField.Request) {
        let trimmedEmail = request.emailTextFieldText?.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let isEmailValid = emailPred.evaluate(with: trimmedEmail)
        
        let response = Login.ValidateEmailTextField.Response(isEmailTextFieldValid: isEmailValid)
        presenter?.presentEmailTextFieldValidation(response: response)
    }
    
    func validatePasswordTextField(request: Login.ValidatePasswordTextField.Request) {
        var isEmailValid: Bool = true
        
        if request.passwordTextFieldText?.count ?? 0 < 6 {
            isEmailValid = false
        }
        
        let response = Login.ValidatePasswordTextField.Response(isPasswordTextFieldValid: isEmailValid)
        presenter?.presentPasswordTextFieldValidation(response: response)
    }
    
    func signIn(request: Login.SignIn.Request) {
        firebaseManager.signInUser(request.email, request.password) { [weak self] isSuccessful in
            let response = Login.SignIn.Response(isSignInSuccessful: isSuccessful)
            self?.presenter?.presentSignInResult(response: response)
        }
    }
    
    init(firebaseManager: FirebaseAuthenticationLogic) {
        self.firebaseManager = firebaseManager
    }
}
