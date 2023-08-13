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
    func openLocationInMaps(request: LocationDescription.OpenLocationInMaps.Request)
}

protocol LocationDescriptionDataStore {
    var location: Location! { get set }
}

class LocationDescriptionInteractor: LocationDescriptionBusinessLogic, LocationDescriptionDataStore {
    // MARK: - Properties
    var presenter: LocationDescriptionPresentationLogic?
    var worker: LocationDescriptionWorkingLogic
    var location: Location!
    
    // MARK: - Methods
    func showLocationDescription(request: LocationDescription.ShowLocationDescription.Request) {
        let response = LocationDescription.ShowLocationDescription.Response(location: location)
        presenter?.presentLocationDescription(response: response)
    }
    
    func copyCoordinatesToClipboard(request: LocationDescription.CopyCoordinatesToClipboard.Request) {
        let location = "\(location.coordinates.longitude), \(location.coordinates.latitude)"
        UIPasteboard.general.string = location
        
        let response = LocationDescription.CopyCoordinatesToClipboard.Response()
        presenter?.presentCopiedToClipboardMessage(response: response)
    }
    
    func openLocationInMaps(request: LocationDescription.OpenLocationInMaps.Request) {
        worker.openInMaps(for: location)
    }
    
    // MARK: - Initialization
    init(worker: LocationDescriptionWorkingLogic) {
        self.worker = worker
    }
}
