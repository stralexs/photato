//
//  LoadingPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit

protocol LoadingPresentationLogic {
    func presentSomething(response: Loading.Something.Response)
}

class LoadingPresenter: LoadingPresentationLogic {
    
    weak var viewController: LoadingDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Loading.Something.Response) {
        let viewModel = Loading.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
