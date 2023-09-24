//
//  SignUpInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit
import OSLog

protocol SignUpBusinessLogic {
    func validateNameTextField(request: SignUp.ValidateNameTextField.Request)
    func validateEmailTextField(request: SignUp.ValidateEmailTextField.Request)
    func validatePasswordTextField(request: SignUp.ValidatePasswordTextField.Request)
    func signUp(request: SignUp.SignUp.Request)
    func downloadLocations(request: SignUp.DownloadLocations.Request)
}

protocol SignUpDataStore {}

final class SignUpInteractor: SignUpBusinessLogic, SignUpDataStore {
    var presenter: SignUpPresentationLogic?
    private let firebaseManager: FirebaseAuthenticationLogic
    private let keychainManager: KeychainManagerLogic
    private let logger = Logger()
        
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
        var response = SignUp.SignUp.Response(signUpResult: nil)
        guard let imageData = request.profilePicture.pngData() else { return }
        firebaseManager.signUpUser(request.name,
                                   request.email,
                                   request.password,
                                   imageData) { [weak self] signUpError in
                        
            switch signUpError {
            case nil:
                UserDefaults.standard.set(request.email, forKey: "userEmail")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                
                do {
                    try self?.keychainManager.save(password: request.password.data(using: .utf8) ?? Data(), account: request.email)
                }
                catch let error as KeychainError {
                    switch error {
                        case .duplicateItem:
                        self?.logger.error("\(error.localizedDescription)")
                    case .unknown(_):
                        self?.logger.error("\(error.localizedDescription)")
                    }
                }
            case .signUpError:
                response = SignUp.SignUp.Response(signUpResult: FirebaseError.signUpError)
            case .occupiedEmail:
                response = SignUp.SignUp.Response(signUpResult: FirebaseError.occupiedEmail)
            default:
                response = SignUp.SignUp.Response(signUpResult: FirebaseError.unknown)
            }
            
            self?.presenter?.presentSignUpResult(response: response)
        }
    }
    
    func downloadLocations(request: SignUp.DownloadLocations.Request) {
        LocationsManager.shared.downloadLocations { [weak self] downloadError in
            var response = SignUp.DownloadLocations.Response(downloadResult: nil)
            switch downloadError {
            case nil:
                break
            case .locationsNotLoadedError:
                response = SignUp.DownloadLocations.Response(downloadResult: FirebaseError.locationsNotLoadedError)
            case .downloadImageDataError:
                response = SignUp.DownloadLocations.Response(downloadResult: FirebaseError.downloadImageDataError)
            default:
                response = SignUp.DownloadLocations.Response(downloadResult: FirebaseError.unknown)
            }
            
            self?.presenter?.presentLocationsDownloadCompletion(response: response)
        }
    }
    
    init(firebaseManager: FirebaseAuthenticationLogic, keychainManager: KeychainManagerLogic) {
        self.firebaseManager = firebaseManager
        self.keychainManager = keychainManager
    }
}
