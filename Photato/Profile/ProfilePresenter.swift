//
//  ProfilePresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol ProfilePresentationLogic {
    func presentSomething(response: Profile.Something.Response)
}

class ProfilePresenter: ProfilePresentationLogic {
    
    weak var viewController: ProfileDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Profile.Something.Response) {
        let viewModel = Profile.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
