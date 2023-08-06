//
//  LocationsListConfigurator.swift
//  Photato
//
//  Created by Alexander Strelnikov on 5.08.23.
//

import Foundation

class LocationsListConfigurator {
    func configure(with view: LocationsListViewController) {
        let viewController = view
        let interactor = LocationsListInteractor()
        let presenter = LocationsListPresenter()
        let router = LocationsListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
