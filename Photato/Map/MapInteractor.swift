//
//  MapInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol MapBusinessLogic {
    func checkLocationServicesEnabled(request: Map.CheckLocationServicesEnabled.Request)
    func getUserLocation(request: Map.GetUserLocation.Request)
    func checkAuthorizationStatus(request: Map.CheckAuthorizationStatus.Request)
    func fetchLocations(request: Map.GetLocationsAnnotations.Request)
    func refreshLocations(request: Map.RefreshLocations.Request)
}

protocol MapDataStore {
    var locations: [Location] { get }
}

final class MapInteractor: MapBusinessLogic, MapDataStore {
    //MARK: - Properties
    var locations = [Location]()
    var presenter: MapPresentationLogic?
    var worker: MapWorkingLogic
    
    //MARK: - Methods
    func checkLocationServicesEnabled(request: Map.CheckLocationServicesEnabled.Request) {
        worker.checkLocationServicesStatus { [weak self] isEnabled in
            let response = Map.CheckLocationServicesEnabled.Response(isLocationServicesEnabled: isEnabled)
            self?.presenter?.presentLocationServicesStatus(response: response)
        }
    }
    
    func getUserLocation(request: Map.GetUserLocation.Request) {
        guard let location = worker.getUserLocation() else { return }
        let response = Map.GetUserLocation.Response(location: location)
        presenter?.presentUserLocation(response: response)
    }
    
    func checkAuthorizationStatus(request: Map.CheckAuthorizationStatus.Request) {
        let authorizationStatus = worker.checkAuthorizationStatus()
        let response = Map.CheckAuthorizationStatus.Response(locationAuthorizationStatus: authorizationStatus)
        presenter?.presentAuthorizationStatus(response: response)
    }
    
    func fetchLocations(request: Map.GetLocationsAnnotations.Request) {
        LocationsManager.shared.provideLocations { [weak self] result in
            let response: Map.GetLocationsAnnotations.Response
            switch result {
            case .success(let locations):
                self?.locations = locations
                response = Map.GetLocationsAnnotations.Response(locationsDownloadResult: .success(locations))
            case .failure(let error):
                response = Map.GetLocationsAnnotations.Response(locationsDownloadResult: .failure(error))
            }
            self?.presenter?.presentLocationsAnnotations(response: response)
        }
    }
    
    func refreshLocations(request: Map.RefreshLocations.Request) {
        LocationsManager.shared.provideLocations { [weak self] result in
            let response: Map.RefreshLocations.Response
            switch result {
            case .success(let locations):
                self?.locations = locations
                response = Map.RefreshLocations.Response(locationsDownloadResult: .success(locations))
            case .failure(let error):
                response = Map.RefreshLocations.Response(locationsDownloadResult: .failure(error))
            }
            self?.presenter?.presentRefreshedLocationsAnnotations(response: response)
        }
    }
    
    //MARK: - Initialization
    init(worker: MapWorkingLogic) {
        self.worker = worker
    }
}
