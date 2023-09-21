//
//  MapInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol MapBusinessLogic {
    func checkLocationServicesEnabled(request: Map.CheckLocationServicesEnabled.Request)
    func setupLocationManager(request: Map.SetupLocationManager.Request)
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
    
    func setupLocationManager(request: Map.SetupLocationManager.Request) {
        worker.setupLocationManager()
    }
    
    func checkAuthorizationStatus(request: Map.CheckAuthorizationStatus.Request) {
        let authorizationStatus = worker.checkAuthorizationStatus()
        let response = Map.CheckAuthorizationStatus.Response(locationAuthorizationStatus: authorizationStatus)
        presenter?.presentAuthorizationStatus(response: response)
    }
    
    func fetchLocations(request: Map.GetLocationsAnnotations.Request) {
        worker.fetchLocations(completion: { [weak self] locations in
            self?.locations = locations
            
            let response = Map.GetLocationsAnnotations.Response(locations: locations)
            self?.presenter?.presentLocationsAnnotations(response: response)
        })
    }
    
    func refreshLocations(request: Map.RefreshLocations.Request) {
        locations = LocationsManager.shared.locations
    }
    
    //MARK: - Initialization
    init(worker: MapWorkingLogic) {
        self.worker = worker
    }
}
