//
//  LocationsListInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationsListBusinessLogic {
    func fetchLocations(request: LocationsList.FetchLocations.Request)
}

protocol LocationsListDataStore {
    var locations: [Location] { get }
}

class LocationsListInteractor: LocationsListBusinessLogic, LocationsListDataStore {
    var locations: [Location] = []
    var presenter: LocationsListPresentationLogic?
    var worker: LocationsListInteractorWorker?
    
    func fetchLocations(request: LocationsList.FetchLocations.Request) {
        worker = LocationsListInteractorWorker()
        guard let worker = worker else { return }
        locations = worker.fetchLocations(using: request.searchText)
        
        let response = LocationsList.FetchLocations.Response(locations: locations)
        presenter?.presentLocations(response: response)
    }
}
