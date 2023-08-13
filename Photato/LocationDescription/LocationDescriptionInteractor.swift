//
//  LocationDescriptionInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationDescriptionBusinessLogic {
    func showLocationDescription(request: LocationDescription.ShowLocationDescription.Request)
}

protocol LocationDescriptionDataStore {
    var location: Location! { get set }
}

class LocationDescriptionInteractor: LocationDescriptionBusinessLogic, LocationDescriptionDataStore {
    var presenter: LocationDescriptionPresentationLogic?
    var worker: LocationDescriptionWorker?
    var location: Location!
    
    func showLocationDescription(request: LocationDescription.ShowLocationDescription.Request) {
        worker = LocationDescriptionWorker()
        worker?.doSomeWork()
            
        let response = LocationDescription.ShowLocationDescription.Response(location: location)
        presenter?.presentLocationDescription(response: response)
    }
}
