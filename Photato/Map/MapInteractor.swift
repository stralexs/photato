//
//  MapInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol MapBusinessLogic {
    func doSomething(request: Map.Something.Request)
}

protocol MapDataStore {
    //var name: String { get set }
}

class MapInteractor: MapBusinessLogic, MapDataStore {
    
    var presenter: MapPresentationLogic?
    var worker: MapWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: Map.Something.Request) {
        worker = MapWorker()
        worker?.doSomeWork()
        
        let response = Map.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
