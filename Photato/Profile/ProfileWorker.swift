//
//  ProfileWorker.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol ProfileWorkingLogic {
    func fetchUserFavouriteLocations(completion: @escaping (Result<[Location], FirebaseError>) -> Void)
}

final class ProfileWorker: ProfileWorkingLogic {
    func fetchUserFavouriteLocations(completion: @escaping (Result<[Location], FirebaseError>) -> Void) {
        LocationsManager.shared.provideLocations { result in
            switch result {
            case .success(let locations):
                let userFavoriteLocations = locations.filter { UserManager.shared.user.favoriteLocations.contains($0.name) }
                completion(.success(userFavoriteLocations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
