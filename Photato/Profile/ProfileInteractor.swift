//
//  ProfileInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol ProfileBusinessLogic {
    func doSomething(request: Profile.Something.Request)
}

protocol ProfileDataStore {
    //var name: String { get set }
}

class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
    
    var presenter: ProfilePresentationLogic?
    var worker: ProfileWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: Profile.Something.Request) {
        worker = ProfileWorker()
        worker?.doSomeWork()
        
        let response = Profile.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
