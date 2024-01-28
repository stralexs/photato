//
//  LocationsListInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationsListBusinessLogic {
    func fetchLocations(request: LocationsList.FetchLocations.Request)
    func searchLocations(request: LocationsList.SearchLocations.Request)
    func refreshLocations(requst: LocationsList.RefreshLocations.Requst)
}

protocol LocationsListDataStore {
    var locations: [Location] { get }
}

final class LocationsListInteractor: LocationsListBusinessLogic, LocationsListDataStore {
    //MARK: - Properties
    var locations = [Location]()
    var presenter: LocationsListPresentationLogic?
    var worker: LocationsListWorkingLogic
    
    //MARK: - Methods
    func fetchLocations(request: LocationsList.FetchLocations.Request) {
        worker.fetchLocations { [weak self] result in
            let response: LocationsList.FetchLocations.Response
            switch result {
            case .success(let locations):
                self?.locations = locations.sorted { $0.name < $1.name }
                response = LocationsList.FetchLocations.Response(locatinsDownloadResult: .success(locations))
            case .failure(let error):
                response = LocationsList.FetchLocations.Response(locatinsDownloadResult: .failure(error))
            }
            self?.presenter?.presentLocations(response: response)
        }
    }
    
    func searchLocations(request: LocationsList.SearchLocations.Request) {
        worker.searchLocations(using: request.searchText) { [weak self] locations in
            guard let self else { return }
            self.locations = locations.sorted { $0.name < $1.name }
            let response = LocationsList.SearchLocations.Response(locations: self.locations)
            presenter?.presentSearchedLocations(response: response)
        }
    }
    
    func refreshLocations(requst: LocationsList.RefreshLocations.Requst) {
        worker.fetchLocations { [weak self] result in
            let response: LocationsList.RefreshLocations.Response
            switch result {
            case .success(let locations):
                self?.locations = locations.sorted { $0.name < $1.name }
                response = LocationsList.RefreshLocations.Response(locationsRefreshResult: .success(locations))
            case .failure(let error):
                response = LocationsList.RefreshLocations.Response(locationsRefreshResult: .failure(error))
            }
            self?.presenter?.presentRefreshedLocations(response: response)
        }
    }
    
    //MARK: - Initialization
    init(worker: LocationsListWorkingLogic) {
        self.worker = worker
    }
}
