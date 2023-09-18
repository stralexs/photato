//
//  ProfilePresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol ProfilePresentationLogic {
    func presentUserFavouriteLocations(response: Profile.GetUserFavouriteLocations.Response)
}

final class ProfilePresenter: ProfilePresentationLogic {
    weak var viewController: ProfileDisplayLogic?
        
    func presentUserFavouriteLocations(response: Profile.GetUserFavouriteLocations.Response) {
        let viewModel = Profile.GetUserFavouriteLocations.ViewModel(locations: response.locations)
        viewController?.displayUserFavouriteLocations(viewModel: viewModel)
    }
}
