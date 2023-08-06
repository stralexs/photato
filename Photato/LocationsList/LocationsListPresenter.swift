//
//  LocationsListPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationsListPresentationLogic {
    func presentLocations(response: LocationsList.FetchLocations.Response)
}

class LocationsListPresenter: LocationsListPresentationLogic {
    weak var viewController: LocationsListDisplayLogic?
    var worker: LocationsListPresenterWorker?
    
    func presentLocations(response: LocationsList.FetchLocations.Response) {
        worker = LocationsListPresenterWorker()
        guard let displayedLocations = worker?.getDisplayedLocations(from: response.locations) else { return }
        let viewModel = LocationsList.FetchLocations.ViewModel(displayedLocations: displayedLocations)
        viewController?.displayCourses(viewModel: viewModel)
    }
}
