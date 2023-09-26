//
//  User.swift
//  Photato
//
//  Created by Alexander Sivko on 23.09.23.
//

import Foundation

struct User {
    let uid: String
    let name: String
    let email: String
    let profilePicture: Data
    let favoriteLocations: [String]
    
    func addNewFavoriteLocation(locationName: String) -> Self {
        var newFavoriteLocations = self.favoriteLocations
        newFavoriteLocations.append(locationName)
        
        return .init(uid: uid,
                     name: name,
                     email: email,
                     profilePicture: profilePicture,
                     favoriteLocations: newFavoriteLocations)
    }
    
    func removeLocationFromFavorites(locationName: String) -> Self {
        let newFavoriteLocations = self.favoriteLocations.filter { $0 != locationName }
        
        return .init(uid: uid,
                     name: name,
                     email: email,
                     profilePicture: profilePicture,
                     favoriteLocations: newFavoriteLocations)
    }
    
    func changeUserInfo(newName: String?, newProfilePicture: Data?) -> Self {
        .init(uid: uid,
              name: newName ?? name,
              email: email,
              profilePicture: newProfilePicture ?? profilePicture,
              favoriteLocations: favoriteLocations)
    }
}
