//
//  ProfilePresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol ProfilePresentationLogic {
    func presentUserFavouriteLocations(response: Profile.GetUserFavouriteLocations.Response)
    func presentUserData(response: Profile.FetchUserData.Response)
}

final class ProfilePresenter: ProfilePresentationLogic {
    weak var viewController: ProfileDisplayLogic?
        
    func presentUserFavouriteLocations(response: Profile.GetUserFavouriteLocations.Response) {
        let viewModel: Profile.GetUserFavouriteLocations.ViewModel
        switch response.userLocationsFetchResult {
        case .success(let locations):
            viewModel = Profile.GetUserFavouriteLocations.ViewModel(fetchResultDescription: (locations, nil))
        case .failure(let error):
            viewModel = Profile.GetUserFavouriteLocations.ViewModel(fetchResultDescription: (nil, error.errorDescription))
        }
        viewController?.displayUserFavouriteLocations(viewModel: viewModel)
    }
    
    func presentUserData(response: Profile.FetchUserData.Response) {
        guard let profilePicture = UIImage(data: response.imageData) else { return }
        let viewModel = Profile.FetchUserData.ViewModel(name: response.name, image: profilePicture)
        
        viewController?.displayUserData(viewModel: viewModel)
    }
}
