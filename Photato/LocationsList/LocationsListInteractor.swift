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
        locations = worker.fetchLocations()
        
        let response = LocationsList.FetchLocations.Response(locations: locations)
        presenter?.presentLocations(response: response)
    }
    
    func searchLocations(request: LocationsList.SearchLocations.Request) {
        locations = worker.searchLocations(using: request.searchText).sorted { $0.name < $1.name }
        
        let response = LocationsList.SearchLocations.Response(locations: locations)
        presenter?.presentSearchedLocations(response: response)
    }
    
    func refreshLocations(requst: LocationsList.RefreshLocations.Requst) {
        locations = LocationsManager.shared.locations
        let response = LocationsList.RefreshLocations.Response(locations: locations)
        presenter?.presentRefreshedLocations(response: response)
    }
    
    //MARK: - Initialization
    init(worker: LocationsListWorkingLogic) {
        self.worker = worker
    }
}
