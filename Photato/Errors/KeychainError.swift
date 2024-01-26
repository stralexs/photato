//
//  KeychainError.swift
//  Photato
//
//  Created by Alexander Sivko on 26.01.24.
//

import Foundation

enum KeychainError: Error {
    case duplicateItem
    case unknown(status: OSStatus)
}

extension KeychainError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .duplicateItem:
            "Failed to save data, as it is already in use. Please try again later"
        case .unknown(status: let status):
            "Unknown error occured. Status: \(status)"
        }
    }
}
