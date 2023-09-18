//
//  ProfileInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol ProfileBusinessLogic {
    func getUserFavouriteLocations(request: Profile.GetUserFavouriteLocations.Request)
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
        locations = worker.fetchUserFavouriteLocations().sorted { $0.name < $1.name }
        
        let response = Profile.GetUserFavouriteLocations.Response(locations: locations)
        presenter?.presentUserFavouriteLocations(response: response)
    }
    
    //MARK: - Initialization
    init(worker: ProfileWorkingLogic) {
        self.worker = worker
    }
}
