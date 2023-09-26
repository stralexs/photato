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

final class OpeningInteractor: OpeningBusinessLogic {
    var presenter: OpeningPresentationLogic?
        
    func checkIsUserLoggedIn(request: Opening.CheckIsUserLoggedIn.Request) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        let response = Opening.CheckIsUserLoggedIn.Response(isUserLoggedIn: isUserLoggedIn)
        presenter?.presentIsUserLoggedIn(response: response)
    }
}
