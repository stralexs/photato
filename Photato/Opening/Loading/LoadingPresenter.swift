//
//  LoadingPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit

protocol LoadingPresentationLogic {
    func presentSignInResult(response: Loading.SignInUser.Response)
    func presentLocationsDownloadCompletion(response: Loading.DownloadLocations.Response)
}

class LoadingPresenter: LoadingPresentationLogic {
    weak var viewController: LoadingDisplayLogic?
    
    func presentSignInResult(response: Loading.SignInUser.Response) {
        var viewModel = Loading.SignInUser.ViewModel(signInErrorDescription: nil)
        
        switch response.signInResult {
        case nil:
            break
        case let error as FirebaseError:
            switch error {
            case .signInError:
                viewModel = Loading.SignInUser.ViewModel(signInErrorDescription: "Failed to sign in. Please try to re-enter your details or register")
            default:
                viewModel = Loading.SignInUser.ViewModel(signInErrorDescription: "Unknown error")
            }
        default:
            break
        }
        
        viewController?.displaySignInResult(viewModel: viewModel)
    }
    
    func presentLocationsDownloadCompletion(response: Loading.DownloadLocations.Response) {
        var viewModel = Loading.DownloadLocations.ViewModel(downloadErrorDescription: nil)
        
        switch response.downloadResult {
        case nil:
            break
        case let error as FirebaseError:
            switch error {
            case .locationsNotLoadedError:
                viewModel = Loading.DownloadLocations.ViewModel(downloadErrorDescription: "Failed to load locations. Please try again later")
            case .downloadImageDataError:
                viewModel = Loading.DownloadLocations.ViewModel(downloadErrorDescription: "Failed to load data. Please try again later")
            default:
                viewModel = Loading.DownloadLocations.ViewModel(downloadErrorDescription: "Unknown error")
            }
        default:
            break
        }
        
        viewController?.displayLocationsDownloadResult(viewModel: viewModel)
    }
}
