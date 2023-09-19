//
//  SignUpInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

protocol SignUpBusinessLogic {
    func doSomething(request: SignUp.Something.Request)
}

protocol SignUpDataStore {
    //var name: String { get set }
}

class SignUpInteractor: SignUpBusinessLogic, SignUpDataStore {
    
    var presenter: SignUpPresentationLogic?
    var worker: SignUpWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: SignUp.Something.Request) {
        worker = SignUpWorker()
        worker?.doSomeWork()
        
        let response = SignUp.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
