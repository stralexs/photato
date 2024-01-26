//
//  FirebaseError.swift
//  Photato
//
//  Created by Alexander Sivko on 25.01.24.
//

import Foundation

enum FirebaseError: Error {
    case dataNotLoaded
    case imageDataNotLoaded
    case failedToSignUp
    case occupiedEmail
    case failedToSignIn
    case failedToGetUserData
    case failedToSaveNewData
    case noChanges
    case unknown
}

extension FirebaseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dataNotLoaded:
            return "Failed to load locations. Please try again later"
        case .imageDataNotLoaded:
            return "Failed to load data. Please try again later"
        case .failedToSignUp:
            return "Failed to sign up. Please try again later"
        case .occupiedEmail:
            return "The email address is already in use by another account. Pleasy try another one"
        case .failedToSignIn:
            return "Failed to sign in. Please try to re-enter your details or register"
        case .failedToGetUserData:
            return "Failed to get your data. Please try again later"
        case .failedToSaveNewData:
            return "Failed to save some of your data. Please try again later"
        case .noChanges:
            return "Your new details are identical to previous ones"
        case .unknown:
            return "Unknown error"
        }
    }
}
