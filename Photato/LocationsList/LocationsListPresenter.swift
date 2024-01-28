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
    func presentRefreshedLocations(response: LocationsList.RefreshLocations.Response)
}

final class LocationsListPresenter: LocationsListPresentationLogic {
    weak var viewController: LocationsListDisplayLogic?
    
    func presentLocations(response: LocationsList.FetchLocations.Response) {
        let viewModel: LocationsList.FetchLocations.ViewModel
        switch response.locatinsDownloadResult {
        case .success(let locations):
            viewModel = LocationsList.FetchLocations.ViewModel(locationsDownloadDescription: (locations, nil))
        case .failure(let error):
            viewModel = LocationsList.FetchLocations.ViewModel(locationsDownloadDescription: (nil, error.errorDescription))
        }
        viewController?.displayLocations(viewModel: viewModel)
    }
    
    func presentSearchedLocations(response: LocationsList.SearchLocations.Response) {
        let viewModel = LocationsList.SearchLocations.ViewModel(locations: response.locations)
        viewController?.displaySearchedLocations(viewModel: viewModel)
    }
    
    func presentRefreshedLocations(response: LocationsList.RefreshLocations.Response) {
        let viewModel: LocationsList.RefreshLocations.ViewModel
        switch response.locationsRefreshResult {
        case .success(let locations):
            viewModel = LocationsList.RefreshLocations.ViewModel(locationsRefreshDescription: (locations, nil))
        case .failure(let error):
            viewModel = LocationsList.RefreshLocations.ViewModel(locationsRefreshDescription: (nil, error.errorDescription))
        }
        viewController?.displayRefreshedLocations(viewModel: viewModel)
    }
}
