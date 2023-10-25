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

class LoadingInteractor: LoadingBusinessLogic {
    //MARK: - Properties
    var presenter: LoadingPresentationLogic?
    private let keychainManager: KeychainManagerLogic
    private let firebaseManager: FirebaseAuthenticationLogic
    private let logger = Logger()
    
    //MARK: - Methods
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
                case .failedToSignIn:
                    response = Loading.SignInUser.Response(signInResult: FirebaseError.failedToSignIn)
                case .failedToGetUserData:
                    response = Loading.SignInUser.Response(signInResult: FirebaseError.failedToGetUserData)
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
            case .dataNotLoaded:
                response = Loading.DownloadLocations.Response(downloadResult: FirebaseError.dataNotLoaded)
            case .imageDataNotLoaded:
                response = Loading.DownloadLocations.Response(downloadResult: FirebaseError.imageDataNotLoaded)
            default:
                response = Loading.DownloadLocations.Response(downloadResult: FirebaseError.unknown)
            }
            
            self?.presenter?.presentLocationsDownloadCompletion(response: response)
        }
    }
    
    //MARK: - Initialization
    init(keychainManager: KeychainManagerLogic, firebaseManager: FirebaseAuthenticationLogic) {
        self.keychainManager = keychainManager
        self.firebaseManager = firebaseManager
    }
}
