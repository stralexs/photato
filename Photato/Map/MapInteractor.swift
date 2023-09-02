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
}

protocol MapDataStore {
    var locations: [Location] { get }
}

class MapInteractor: MapBusinessLogic, MapDataStore {
    //MARK: - Properties
    var locations: [Location] = []
    var presenter: MapPresentationLogic?
    var worker: MapWorkingLogic
    
    //MARK: - Methods
    func checkLocationServicesEnabled(request: Map.CheckLocationServicesEnabled.Request) {
        let isLocationServicesEnabled = worker.checkLocationServicesStatus()
        
        let response = Map.CheckLocationServicesEnabled.Response(isLocationServicesEnabled: isLocationServicesEnabled)
        presenter?.presentLocationServicesStatus(response: response)
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
        locations = worker.fetchLocations()
        
        let response = Map.GetLocationsAnnotations.Response(locations: locations)
        presenter?.presentLocationsAnnotations(response: response)
    }
    
    //MARK: - Initialization
    init(worker: MapWorkingLogic) {
        self.worker = worker
    }
}
