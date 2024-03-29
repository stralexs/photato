//
//  ProfileInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol ProfileBusinessLogic {
    func getUserFavouriteLocations(request: Profile.GetUserFavouriteLocations.Request)
    func fetchUserData(request: Profile.FetchUserData.Request)
}

protocol ProfileDataStore {
    var locations: [Location] { get }
}

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
    //MARK: - Properties
    var presenter: ProfilePresentationLogic?
    var worker: ProfileWorkingLogic
    var locations = [Location]()
    
    //MARK: - Methods
    func getUserFavouriteLocations(request: Profile.GetUserFavouriteLocations.Request) {
        worker.fetchUserFavouriteLocations { [weak self] result in
            guard let self else { return }
            let response: Profile.GetUserFavouriteLocations.Response
            switch result {
            case .success(let userLocations):
                self.locations = userLocations.sorted { $0.name < $1.name }
                response = Profile.GetUserFavouriteLocations.Response(userLocationsFetchResult: .success(self.locations))
                self.presenter?.presentUserFavouriteLocations(response: response)
            case .failure(let error):
                response = Profile.GetUserFavouriteLocations.Response(userLocationsFetchResult: .failure(error))
            }
            self.presenter?.presentUserFavouriteLocations(response: response)
        }
    }
    
    func fetchUserData(request: Profile.FetchUserData.Request) {
        let name = UserManager.shared.user.name
        let imageData = UserManager.shared.user.profilePicture
        
        let response = Profile.FetchUserData.Response(name: name, imageData: imageData)
        presenter?.presentUserData(response: response)
    }
    
    //MARK: - Initialization
    init(worker: ProfileWorkingLogic) {
        self.worker = worker
    }
}
