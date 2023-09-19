//
//  SignUpPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

protocol SignUpPresentationLogic {
    func presentSomething(response: SignUp.Something.Response)
}

class SignUpPresenter: SignUpPresentationLogic {
    
    weak var viewController: SignUpDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: SignUp.Something.Response) {
        let viewModel = SignUp.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
