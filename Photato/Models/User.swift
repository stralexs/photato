//
//  User.swift
//  Photato
//
//  Created by Alexander Sivko on 23.09.23.
//

import Foundation

struct User {
    let name: String
    let email: String
    let password: String
    let profilePicture: Data
    let favoriteLocations: [String]
    
    func addNewFavoriteLocation(locationName: String) -> Self {
        var newFavoriteLocations = self.favoriteLocations
        newFavoriteLocations.append(locationName)
        
        return .init(name: name,
                email: email,
                password: password,
                profilePicture: profilePicture,
                favoriteLocations: newFavoriteLocations)
    }
    
    func removeLocationFromFavorites(locationName: String) -> Self {
        let newFavoriteLocations = self.favoriteLocations.filter { $0 != locationName }
        
        return .init(name: name,
                email: email,
                password: password,
                profilePicture: profilePicture,
                favoriteLocations: newFavoriteLocations)
    }
    
    func changeUserInfo(newName: String?, newProfilePicture: Data?) -> Self {
        .init(name: newName ?? name,
              email: email,
              password: password,
              profilePicture: newProfilePicture ?? profilePicture,
              favoriteLocations: favoriteLocations)
    }
}
