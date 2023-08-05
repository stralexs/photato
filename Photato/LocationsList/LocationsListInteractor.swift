//
//  LocationsListInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationsListBusinessLogic {
    func doSomething(request: LocationsList.Something.Request)
}

protocol LocationsListDataStore {
    //var name: String { get set }
}

class LocationsListInteractor: LocationsListBusinessLogic, LocationsListDataStore {
    
    var presenter: LocationsListPresentationLogic?
    var worker: LocationsListWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: LocationsList.Something.Request) {
        worker = LocationsListWorker()
        worker?.doSomeWork()
        
        let response = LocationsList.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
