//
//  LocationDescriptionPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationDescriptionPresentationLogic {
    func presentSomething(response: LocationDescription.Something.Response)
}

class LocationDescriptionPresenter: LocationDescriptionPresentationLogic {
    
    weak var viewController: LocationDescriptionDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: LocationDescription.Something.Response) {
        let viewModel = LocationDescription.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
