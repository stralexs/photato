//
//  OpeningPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

protocol OpeningPresentationLogic {
    func presentIsUserLoggedIn(response: Opening.CheckIsUserLoggedIn.Response)
}

final class OpeningPresenter: OpeningPresentationLogic {
    weak var viewController: OpeningDisplayLogic?
    
    func presentIsUserLoggedIn(response: Opening.CheckIsUserLoggedIn.Response) {
        let viewModel = Opening.CheckIsUserLoggedIn.ViewModel(isUserLoggedIn: response.isUserLoggedIn)
        viewController?.displayIsUserLoggedIn(viewModel: viewModel)
    }
}
