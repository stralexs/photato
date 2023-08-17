//
//  MapPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol MapPresentationLogic {
    func presentLocationServicesStatus(response: Map.CheckLocationServicesEnabled.Response)
    func presentAuthorizationStatus(response: Map.CheckAuthorizationStatus.Response)
}

class MapPresenter: MapPresentationLogic {
    weak var viewController: MapDisplayLogic?
        
    func presentLocationServicesStatus(response: Map.CheckLocationServicesEnabled.Response) {
        let isLocationServicesEnabled = response.isLocationServicesEnabled
        let viewModel = Map.CheckLocationServicesEnabled.ViewModel(isLocationServicesEnabled: isLocationServicesEnabled)
        viewController?.displayLocationServicesStatus(viewModel: viewModel)
    }
    
    func presentAuthorizationStatus(response: Map.CheckAuthorizationStatus.Response) {
        let authorizationStatus = response.locationAuthorizationStatus
        let viewModel = Map.CheckAuthorizationStatus.ViewModel(locationAuthorizationStatus: authorizationStatus)
        viewController?.displayAuthorizationStatus(viewModel: viewModel)
    }
}
