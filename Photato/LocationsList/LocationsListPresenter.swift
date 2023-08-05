//
//  LocationsListPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationsListPresentationLogic {
    func presentSomething(response: LocationsList.Something.Response)
}

class LocationsListPresenter: LocationsListPresentationLogic {
    
    weak var viewController: LocationsListDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: LocationsList.Something.Response) {
        let viewModel = LocationsList.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
