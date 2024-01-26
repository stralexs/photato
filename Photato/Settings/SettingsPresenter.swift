//
//  SettingsPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 27.09.23.
//

import UIKit

protocol SettingsPresentationLogic {
    func presentUserData(response: Settings.GetUserData.Response)
    func presentNameTextFieldValidation(response: Settings.ValidateNameTextField.Response)
    func presentApplyChangesResult(response: Settings.ApplyChanges.Response)
    func presentLeaveAccount(response: Settings.LeaveAccount.Response)
}

final class SettingsPresenter: SettingsPresentationLogic {
    weak var viewController: SettingsDisplayLogic?
    
    func presentUserData(response: Settings.GetUserData.Response) {
        let name = response.user.name
        let pictureData = response.user.profilePicture
        
        let viewModel = Settings.GetUserData.ViewModel(userData: (name, pictureData))
        viewController?.displayUserData(viewModel: viewModel)
    }
    
    func presentNameTextFieldValidation(response: Settings.ValidateNameTextField.Response) {
        var nameTextFieldValidationDescription: String?
        if response.isNameTextFieldValid == false {
            nameTextFieldValidationDescription = "Please fill name field"
        }
        
        let viewModel = Settings.ValidateNameTextField.ViewModel(nameTextFieldValidationDescription: nameTextFieldValidationDescription)
        viewController?.displayNameTextFieldValidation(viewModel: viewModel)
    }
    
    func presentApplyChangesResult(response: Settings.ApplyChanges.Response) {
        let viewModel: Settings.ApplyChanges.ViewModel
        switch response.applyChangesResult {
        case let error as FirebaseError:
            viewModel = Settings.ApplyChanges.ViewModel(applyChangesErrorDescription: error.errorDescription)
        default:
            viewModel = Settings.ApplyChanges.ViewModel(applyChangesErrorDescription: nil)
        }
        
        viewController?.displayApplyChangesResult(viewModel: viewModel)
    }
    
    func presentLeaveAccount(response: Settings.LeaveAccount.Response) {
        let viewModel = Settings.LeaveAccount.ViewModel()
        viewController?.displayLeaveAccount(viewModel: viewModel)
    }
}
