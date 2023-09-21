//
//  OpeningInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

protocol OpeningBusinessLogic {
    func checkIsUserLoggedIn(request: Opening.CheckIsUserLoggedIn.Request)
}

protocol OpeningDataStore {}

final class OpeningInteractor: OpeningBusinessLogic, OpeningDataStore {
    var presenter: OpeningPresentationLogic?
        
    func checkIsUserLoggedIn(request: Opening.CheckIsUserLoggedIn.Request) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        let response = Opening.CheckIsUserLoggedIn.Response(isUserLoggedIn: isUserLoggedIn)
        presenter?.presentIsUserLoggedIn(response: response)
    }
}
