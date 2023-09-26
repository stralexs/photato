//
//  LoginInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit
import OSLog

protocol LoginBusinessLogic {
    func validateEmailTextField(request: Login.ValidateEmailTextField.Request)
    func validatePasswordTextField(request: Login.ValidatePasswordTextField.Request)
    func signIn(request: Login.SignIn.Request)
    func downloadLocations(request: Login.DownloadLocations.Request)
}

protocol LoginDataStore {}

final class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    var presenter: LoginPresentationLogic?
    private let firebaseManager: FirebaseAuthenticationLogic
    private let keychainManager: KeychainManagerLogic
    private let logger = Logger()
    
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
        firebaseManager.signInUser(request.email, request.password) { [weak self] signInError in
            var response = Login.SignIn.Response(signInResult: nil)
            
            switch signInError {
            case nil:
                UserDefaults.standard.set(request.email, forKey: "userEmail")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                
                do {
                    try self?.keychainManager.save(password: request.password.data(using: .utf8) ?? Data(),
                                                   account: request.email)
                }
                
                catch let error as KeychainError {
                    switch error {
                        case .duplicateItem:
                        self?.logger.error("\(error.localizedDescription)")
                    case .unknown(_):
                        self?.logger.error("\(error.localizedDescription)")
                    }
                }
            case .failedToSignIn:
                response = Login.SignIn.Response(signInResult: FirebaseError.failedToSignIn)
            case .failedToGetUserData:
                response = Login.SignIn.Response(signInResult: FirebaseError.failedToGetUserData)
            default:
                response = Login.SignIn.Response(signInResult: FirebaseError.unknown)
            }
            
            self?.presenter?.presentSignInResult(response: response)
        }
    }
    
    func downloadLocations(request: Login.DownloadLocations.Request) {
        LocationsManager.shared.downloadLocations { [weak self] downloadError in
            var response = Login.DownloadLocations.Response(downloadResult: nil)
            switch downloadError {
            case nil:
                break
            case .dataNotLoaded:
                response = Login.DownloadLocations.Response(downloadResult: FirebaseError.dataNotLoaded)
            case .imageDataNotLoaded:
                response = Login.DownloadLocations.Response(downloadResult: FirebaseError.imageDataNotLoaded)
            default:
                response = Login.DownloadLocations.Response(downloadResult: FirebaseError.unknown)
            }
            
            self?.presenter?.presentLocationsDownloadCompletion(response: response)
        }
    }
    
    init(firebaseManager: FirebaseAuthenticationLogic, keychainManager: KeychainManagerLogic) {
        self.firebaseManager = firebaseManager
        self.keychainManager = keychainManager
    }
}
