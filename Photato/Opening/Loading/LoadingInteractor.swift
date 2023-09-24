//
//  LoadingInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit
import OSLog

protocol LoadingBusinessLogic {
    func signInUser(request: Loading.SignInUser.Request)
    func downloadLocations(request: Loading.DownloadLocations.Request)
}

protocol LoadingDataStore {}

class LoadingInteractor: LoadingBusinessLogic, LoadingDataStore {
    var presenter: LoadingPresentationLogic?
    private let keychainManager: KeychainManagerLogic
    private let firebaseManager: FirebaseAuthenticationLogic
    private let logger = Logger()
    
    func signInUser(request: Loading.SignInUser.Request) {
        guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else { return }
        
        do {
            let passwordData = try keychainManager.getPassword(for: userEmail)
            let password = String(decoding: passwordData ?? Data(), as: UTF8.self)
            
            firebaseManager.signInUser(userEmail, password) { [weak self] signInError in
                var response = Loading.SignInUser.Response(signInResult: nil)
                
                switch signInError {
                case nil:
                    break
                case .signInError:
                    response = Loading.SignInUser.Response(signInResult: FirebaseError.signInError)
                default:
                    response = Loading.SignInUser.Response(signInResult: FirebaseError.unknown)
                    
                }
                
                self?.presenter?.presentSignInResult(response: response)
            }
        }
        catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    func downloadLocations(request: Loading.DownloadLocations.Request) {
        LocationsManager.shared.downloadLocations { [weak self] downloadError in
            var response = Loading.DownloadLocations.Response(downloadResult: nil)
            switch downloadError {
            case nil:
                break
            case .locationsNotLoadedError:
                response = Loading.DownloadLocations.Response(downloadResult: FirebaseError.locationsNotLoadedError)
            case .downloadImageDataError:
                response = Loading.DownloadLocations.Response(downloadResult: FirebaseError.downloadImageDataError)
            default:
                response = Loading.DownloadLocations.Response(downloadResult: FirebaseError.unknown)
            }
            
            self?.presenter?.presentLocationsDownloadCompletion(response: response)
        }
    }
    
    init(keychainManager: KeychainManagerLogic, firebaseManager: FirebaseAuthenticationLogic) {
        self.keychainManager = keychainManager
        self.firebaseManager = firebaseManager
    }
}
