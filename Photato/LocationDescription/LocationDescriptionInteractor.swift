//
//  LocationDescriptionInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationDescriptionBusinessLogic {
    func doSomething(request: LocationDescription.Something.Request)
}

protocol LocationDescriptionDataStore {
    //var name: String { get set }
}

class LocationDescriptionInteractor: LocationDescriptionBusinessLogic, LocationDescriptionDataStore {
    
    var presenter: LocationDescriptionPresentationLogic?
    var worker: LocationDescriptionWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: LocationDescription.Something.Request) {
        worker = LocationDescriptionWorker()
        worker?.doSomeWork()
        
        let response = LocationDescription.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
