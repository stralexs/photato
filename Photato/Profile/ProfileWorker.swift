//
//  ProfileWorker.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol ProfileWorkingLogic {
    func fetchUserFavouriteLocations() -> [Location]
}

final class ProfileWorker: ProfileWorkingLogic {
    func fetchUserFavouriteLocations() -> [Location] {
        LocationsManager.shared.locations.filter { UserManager.shared.user.favoriteLocations.contains($0.name) }
    }
}
