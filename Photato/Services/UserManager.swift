//
//  UserManager.swift
//  Photato
//
//  Created by Alexander Sivko on 23.09.23.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    private init() {
        user = User(uid: "", name: "", email: "", profilePicture: Data(), favoriteLocations: [])
    }
    
    var user: User
}
