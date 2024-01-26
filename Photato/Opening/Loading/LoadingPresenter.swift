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
        let viewModel: Loading.SignInUser.ViewModel
        switch response.signInResult {
        case let error as FirebaseError:
            viewModel = Loading.SignInUser.ViewModel(signInErrorDescription: error.errorDescription)
        default:
            viewModel = Loading.SignInUser.ViewModel(signInErrorDescription: nil)
        }
        
        viewController?.displaySignInResult(viewModel: viewModel)
    }
    
    func presentLocationsDownloadCompletion(response: Loading.DownloadLocations.Response) {
        let viewModel: Loading.DownloadLocations.ViewModel
        switch response.downloadResult {
        case let error as FirebaseError:
            viewModel = Loading.DownloadLocations.ViewModel(downloadErrorDescription: error.errorDescription)
        default:
            viewModel = Loading.DownloadLocations.ViewModel(downloadErrorDescription: nil)
        }
        
        viewController?.displayLocationsDownloadResult(viewModel: viewModel)
    }
}
