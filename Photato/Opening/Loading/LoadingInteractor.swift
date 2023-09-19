//
//  LoadingInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit

protocol LoadingBusinessLogic {
    func doSomething(request: Loading.Something.Request)
}

protocol LoadingDataStore {
    //var name: String { get set }
}

class LoadingInteractor: LoadingBusinessLogic, LoadingDataStore {
    
    var presenter: LoadingPresentationLogic?
    var worker: LoadingWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: Loading.Something.Request) {
        worker = LoadingWorker()
        worker?.doSomeWork()
        
        let response = Loading.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
