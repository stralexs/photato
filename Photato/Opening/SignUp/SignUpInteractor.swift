//
//  SignUpInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

protocol SignUpBusinessLogic {
    func validateNameTextField(request: SignUp.ValidateNameTextField.Request)
    func validateEmailTextField(request: SignUp.ValidateEmailTextField.Request)
    func validatePasswordTextField(request: SignUp.ValidatePasswordTextField.Request)
    func signUp(request: SignUp.SignUp.Request)
}

protocol SignUpDataStore {}

final class SignUpInteractor: SignUpBusinessLogic, SignUpDataStore {
    var presenter: SignUpPresentationLogic?
    private let firebaseManager: FirebaseAuthenticationLogic
        
    func validateNameTextField(request: SignUp.ValidateNameTextField.Request) {
        let trimmedName = request.nameTextFieldText?.trimmingCharacters(in: .whitespacesAndNewlines)
        var isTextFieldTextValid: Bool = true
        
        if trimmedName == "" {
            isTextFieldTextValid = false
        }
                
        let response = SignUp.ValidateNameTextField.Response(isNameTextFieldValid: isTextFieldTextValid)
        presenter?.presentNameTextFieldValidation(response: response)
    }
    
    func validateEmailTextField(request: SignUp.ValidateEmailTextField.Request) {
        let trimmedEmail = request.emailTextFieldText?.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let isEmailValid = emailPred.evaluate(with: trimmedEmail)
        
        let response = SignUp.ValidateEmailTextField.Response(isEmailTextFieldValid: isEmailValid)
        presenter?.presentEmailTextFieldValidation(response: response)
    }
    
    func validatePasswordTextField(request: SignUp.ValidatePasswordTextField.Request) {
        var isEmailValid: Bool = true
        
        if request.passwordTextFieldText?.count ?? 0 < 6 {
            isEmailValid = false
        }
        
        let response = SignUp.ValidatePasswordTextField.Response(isPasswordTextFieldValid: isEmailValid)
        presenter?.presentPasswordTextFieldValidation(response: response)
    }
    
    func signUp(request: SignUp.SignUp.Request) {
        guard let imageData = request.profilePicture.pngData() else { return }
        firebaseManager.signUpUser(request.name,
                                   request.email,
                                   request.password,
                                   imageData)
        
        let response = SignUp.SignUp.Response(isSignUpSuccessful: true)
        presenter?.presentSignUpResult(response: response)
    }
    
    init(firebaseManager: FirebaseAuthenticationLogic) {
        self.firebaseManager = firebaseManager
    }
}
