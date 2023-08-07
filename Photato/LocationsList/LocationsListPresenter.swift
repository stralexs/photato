//
//  LocationsListPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationsListPresentationLogic {
    func presentLocations(response: LocationsList.FetchLocations.Response)
    func presentSearchedLocations(response: LocationsList.SearchLocations.Response)
}

class LocationsListPresenter: LocationsListPresentationLogic {
    weak var viewController: LocationsListDisplayLogic?
    
    func presentLocations(response: LocationsList.FetchLocations.Response) {
        let sortedLocations = response.locations.sorted { $0.name < $1.name }
        let viewModel = LocationsList.FetchLocations.ViewModel(locations: sortedLocations)
        viewController?.displayLocations(viewModel: viewModel)
    }
    
    func presentSearchedLocations(response: LocationsList.SearchLocations.Response) {
        let sortedLocations = response.locations.sorted { $0.name < $1.name }
        let viewModel = LocationsList.SearchLocations.ViewModel(locations: sortedLocations)
        viewController?.displaySearchedLocations(viewModel: viewModel)
    }
}
