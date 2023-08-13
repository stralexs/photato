//
//  LocationDescriptionInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationDescriptionBusinessLogic {
    func showLocationDescription(request: LocationDescription.ShowLocationDescription.Request)
    func copyCoordinatesToClipboard(request: LocationDescription.CopyCoordinatesToClipboard.Request)
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
    
    func copyCoordinatesToClipboard(request: LocationDescription.CopyCoordinatesToClipboard.Request) {
        let location = "\(location.coordinates.longitude), \(location.coordinates.latitude)"
        UIPasteboard.general.string = location
        
        let response = LocationDescription.CopyCoordinatesToClipboard.Response()
        presenter?.presentCopiedToClipboardMessage(response: response)
    }
}
