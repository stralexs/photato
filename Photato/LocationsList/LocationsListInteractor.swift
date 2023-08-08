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
}

class LocationsListInteractor: LocationsListBusinessLogic, LocationsListDataStore {
    var locations: [Location] = []
    var presenter: LocationsListPresentationLogic?
    var worker: LocationsListWorkingLogic = LocationsListWorker()
    
    func fetchLocations(request: LocationsList.FetchLocations.Request) {
        locations = worker.fetchLocations()
        
        let response = LocationsList.FetchLocations.Response(locations: locations)
        presenter?.presentLocations(response: response)
    }
    
    func searchLocations(request: LocationsList.SearchLocations.Request) {
        locations = worker.searchLocations(using: request.searchText)
        
        let response = LocationsList.SearchLocations.Response(locations: locations)
        presenter?.presentSearchedLocations(response: response)
    }
}
