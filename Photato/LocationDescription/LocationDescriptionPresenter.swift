//
//  LocationDescriptionPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationDescriptionPresentationLogic {
    func presentLocationDescription(response: LocationDescription.ShowLocationDescription.Response)
    func presentCopiedToClipboardMessage(response: LocationDescription.CopyCoordinatesToClipboard.Response)
    func presentLocationImagesCount(response: LocationDescription.GetLocationImagesCount.Response)
    func presentLocationAllImages(response: LocationDescription.GetLocationAllImages.Response)
    func presentNewFavoriteStatus(response: LocationDescription.SetLocationFavoriteStatus.Response)
}

final class LocationDescriptionPresenter: LocationDescriptionPresentationLogic {
    weak var viewController: LocationDescriptionDisplayLogic?
    
    func presentLocationDescription(response: LocationDescription.ShowLocationDescription.Response) {
        let longitude = round(100_000 * response.location.coordinates.longitude) / 100_000
        let latitude = round(100_000 * response.location.coordinates.latitude) / 100_000
        let coordinates = "\(latitude), \(longitude)"
        
        let viewModel = LocationDescription.ShowLocationDescription.ViewModel(location: response.location,
                                                                              stringLocationCoordinates: coordinates,
                                                                              isFavorite: response.isFavorite)
        viewController?.displayLocationDescription(viewModel: viewModel)
    }
    
    func presentCopiedToClipboardMessage(response: LocationDescription.CopyCoordinatesToClipboard.Response) {
        let viewModel = LocationDescription.CopyCoordinatesToClipboard.ViewModel()
        viewController?.displayCopiedToClipboardMessage(viewModel: viewModel)
    }
    
    func presentLocationImagesCount(response: LocationDescription.GetLocationImagesCount.Response) {
        let viewModel = LocationDescription.GetLocationImagesCount.ViewModel(imagesCount: response.imagesCount)
        viewController?.displayLocationImagesCount(viewModel: viewModel)
    }
    
    func presentLocationAllImages(response: LocationDescription.GetLocationAllImages.Response) {
        let viewModel: LocationDescription.GetLocationAllImages.ViewModel
        switch response.downloadResult {
        case .success(let imagesData):
            viewModel = LocationDescription.GetLocationAllImages.ViewModel(downloadResultDescription: (imagesData, nil))
        case .failure(let error):
            viewModel = LocationDescription.GetLocationAllImages.ViewModel(downloadResultDescription: (nil, error.errorDescription))
        }
        
        viewController?.displayLocationAllImages(viewModel: viewModel)
    }
    
    func presentNewFavoriteStatus(response: LocationDescription.SetLocationFavoriteStatus.Response) {
        let viewModel = LocationDescription.SetLocationFavoriteStatus.ViewModel(isFavorite: response.isFavorite)
        viewController?.displayLocationNewFavoriteStatus(viewModel: viewModel)
    }
}
