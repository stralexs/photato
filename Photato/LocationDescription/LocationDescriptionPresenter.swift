//
//  LocationDescriptionPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationDescriptionPresentationLogic {
    func presentLocationDescription(response: LocationDescription.ShowLocationDescription.Response)
}

class LocationDescriptionPresenter: LocationDescriptionPresentationLogic {
    weak var viewController: LocationDescriptionDisplayLogic?
    
    func presentLocationDescription(response: LocationDescription.ShowLocationDescription.Response) {
        guard let imageData = response.location.imagesData.first else { return }
        let longitude = round(100_000 * response.location.coordinates.longitude) / 100_000
        let latitude = round(100_000 * response.location.coordinates.latitude) / 100_000
        let coordinates = "\(longitude), \(latitude)"
        
        let displayedLocation = LocationDescription.ShowLocationDescription.ViewModel.DisplayedLocation(
                name: response.location.name,
                description: response.location.description,
                address: response.location.address,
                coordinates: coordinates, imagesData: [imageData])
        
        let viewModel = LocationDescription.ShowLocationDescription.ViewModel(displayedLocation: displayedLocation)
        viewController?.displayLocationDescription(viewModel: viewModel)
    }
}
