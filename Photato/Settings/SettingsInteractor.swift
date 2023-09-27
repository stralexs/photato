//
//  SettingsInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 27.09.23.
//

import UIKit

protocol SettingsBusinessLogic {
    func getUserData(request: Settings.GetUserData.Request)
    func validateNameTextField(request: Settings.ValidateNameTextField.Request)
    func applyChanges(request: Settings.ApplyChanges.Request)
    func leaveAccount(request: Settings.LeaveAccount.Request)
}

class SettingsInteractor: SettingsBusinessLogic {
    var presenter: SettingsPresentationLogic?
    private let firebaseManager: FirebaseUserLogic
    
    func getUserData(request: Settings.GetUserData.Request) {
        let user = UserManager.shared.user
        
        let response = Settings.GetUserData.Response(user: user)
        presenter?.presentUserData(response: response)
    }
    
    func validateNameTextField(request: Settings.ValidateNameTextField.Request) {
        let trimmedName = request.nameTextFieldText?.trimmingCharacters(in: .whitespacesAndNewlines)
        var isTextFieldTextValid: Bool = true
        
        if trimmedName == "" {
            isTextFieldTextValid = false
        }
                
        let response = Settings.ValidateNameTextField.Response(isNameTextFieldValid: isTextFieldTextValid)
        presenter?.presentNameTextFieldValidation(response: response)
    }
    
    func applyChanges(request: Settings.ApplyChanges.Request) {
        var response = Settings.ApplyChanges.Response(applyChangesResult: nil)
        
        if request.name != UserManager.shared.user.name {
            firebaseManager.changeUserName(request.name) { [weak self] error in
                switch error {
                case nil:
                    UserManager.shared.user = UserManager.shared.user.changeUserInfo(newName: request.name, newEmail: nil, newProfilePicture: nil)
                case .failedToSaveNewData:
                    response = Settings.ApplyChanges.Response(applyChangesResult: FirebaseError.failedToSaveNewData)
                default:
                    response = Settings.ApplyChanges.Response(applyChangesResult: FirebaseError.unknown)
                }
                self?.presenter?.presentApplyChangesResult(response: response)
            }
        }
        
        guard let imageData = request.profilePicture.pngData() else { return }
        if imageData != UserManager.shared.user.profilePicture {
            firebaseManager.changeUserProfilePicture(imageData) { [weak self] error in
                switch error {
                case nil:
                    UserManager.shared.user = UserManager.shared.user.changeUserInfo(newName: nil, newEmail: nil, newProfilePicture: imageData)
                case .failedToSaveNewData:
                    response = Settings.ApplyChanges.Response(applyChangesResult: FirebaseError.failedToSaveNewData)
                default:
                    response = Settings.ApplyChanges.Response(applyChangesResult: FirebaseError.unknown)
                }
                self?.presenter?.presentApplyChangesResult(response: response)
            }
        }
        
        if request.name == UserManager.shared.user.name,
           imageData == UserManager.shared.user.profilePicture {
            response = Settings.ApplyChanges.Response(applyChangesResult: FirebaseError.noChanges)
            presenter?.presentApplyChangesResult(response: response)
        }
    }
    
    func leaveAccount(request: Settings.LeaveAccount.Request) {
        UserDefaults.standard.set(nil, forKey: "userEmail")
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        
        let response = Settings.LeaveAccount.Response()
        presenter?.presentLeaveAccount(response: response)
    }
    
    init(firbaseManager: FirebaseUserLogic) {
        self.firebaseManager = firbaseManager
    }
}
