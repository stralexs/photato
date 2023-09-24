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
    func getLocationImagesCount(request: LocationDescription.GetLocationImagesCount.Request)
    func getLocationAllImages(request: LocationDescription.GetLocationAllImages.Request)
}

protocol LocationDescriptionDataStore {
    var location: Location? { get set }
}

final class LocationDescriptionInteractor: LocationDescriptionBusinessLogic, LocationDescriptionDataStore {
    // MARK: - Properties
    var presenter: LocationDescriptionPresentationLogic?
    var worker: LocationDescriptionWorkingLogic
    var location: Location?
    
    // MARK: - Methods
    func showLocationDescription(request: LocationDescription.ShowLocationDescription.Request) {
        guard let location = location else { return }
        let response = LocationDescription.ShowLocationDescription.Response(location: location)
        presenter?.presentLocationDescription(response: response)
    }
    
    func copyCoordinatesToClipboard(request: LocationDescription.CopyCoordinatesToClipboard.Request) {
        guard let location = location else { return }
        let pasteboardLocation = "\(location.coordinates.latitude), \(location.coordinates.longitude)"
        UIPasteboard.general.string = pasteboardLocation
        
        let response = LocationDescription.CopyCoordinatesToClipboard.Response()
        presenter?.presentCopiedToClipboardMessage(response: response)
    }
    
    func openLocationInMaps(request: LocationDescription.OpenLocationInMaps.Request) {
        guard let location = location else { return }
        worker.openInMaps(for: location)
    }
    
    func getLocationImagesCount(request: LocationDescription.GetLocationImagesCount.Request) {
        guard let location = location else { return }
        if location.imagesData.count == 1 {
            LocationsManager.shared.downloadImagesCount(for: location.name) { [presenter] imagesCount in
                let response = LocationDescription.GetLocationImagesCount.Response(imagesCount: imagesCount)
                presenter?.presentLocationImagesCount(response: response)
            }
        } else {
            let response = LocationDescription.GetLocationImagesCount.Response(imagesCount: location.imagesData.count)
            presenter?.presentLocationImagesCount(response: response)
        }
    }
    
    func getLocationAllImages(request: LocationDescription.GetLocationAllImages.Request) {
        guard let location = location else { return }
        if location.imagesData.count == 1 {
            LocationsManager.shared.downloadAllImages(for: location.name) { [weak self] result in
                switch result {
                case .success(let imagesData):
                    let response = LocationDescription.GetLocationAllImages.Response(downloadResult: .success(imagesData))
                    self?.presenter?.presentLocationAllImages(response: response)
                case .failure(let error):
                    let response = LocationDescription.GetLocationAllImages.Response(downloadResult: .failure(error))
                    self?.presenter?.presentLocationAllImages(response: response)
                }
            }
        } else {
            let response = LocationDescription.GetLocationAllImages.Response(downloadResult: .success(location.imagesData))
            presenter?.presentLocationAllImages(response: response)
        }
    }
    
    // MARK: - Initialization
    init(worker: LocationDescriptionWorkingLogic) {
        self.worker = worker
    }
}
