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
        return LocationsManager.shared.locations
    }
}
