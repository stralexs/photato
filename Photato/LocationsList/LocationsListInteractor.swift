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
}

protocol LocationsListDataStore {
    var locations: [Location] { get }
    var selectedLocation: Location? { get }
}

class LocationsListInteractor: LocationsListBusinessLogic, LocationsListDataStore {
    //MARK: - Properties
    var locations: [Location] = []
    var selectedLocation: Location?
    var presenter: LocationsListPresentationLogic?
    var worker: LocationsListWorkingLogic
    
    //MARK: - Public Methods
    func fetchLocations(request: LocationsList.FetchLocations.Request) {
        locations = worker.fetchLocations()
        locations = sortLocations()
        
        let response = LocationsList.FetchLocations.Response(locations: locations)
        presenter?.presentLocations(response: response)
    }
    
    func searchLocations(request: LocationsList.SearchLocations.Request) {
        locations = worker.searchLocations(using: request.searchText)
        locations = sortLocations()
        
        let response = LocationsList.SearchLocations.Response(locations: locations)
        presenter?.presentSearchedLocations(response: response)
    }
    
    //MARK: - Private Method
    private func sortLocations() -> [Location] {
        return locations.sorted { $0.name < $1.name }
    }
    
    //MARK: - Initialization
    init(worker: LocationsListWorkingLogic) {
        self.worker = worker
    }
}
