//
//  MapPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol MapPresentationLogic {
    func presentSomething(response: Map.Something.Response)
}

class MapPresenter: MapPresentationLogic {
    
    weak var viewController: MapDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Map.Something.Response) {
        let viewModel = Map.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
