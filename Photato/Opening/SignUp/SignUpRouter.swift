//
//  SignUpRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

@objc protocol SignUpRoutingLogic {
    func routeToTabBarController()
}

protocol SignUpDataPassing {
    var dataStore: SignUpDataStore? { get }
}

final class SignUpRouter: NSObject, SignUpRoutingLogic, SignUpDataPassing {
    weak var viewController: SignUpViewController?
    var dataStore: SignUpDataStore?
    
    // MARK: - Routing
    func routeToTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        navigateToTabBarController(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    private func navigateToTabBarController(source: SignUpViewController, destination: TabBarController) {
        source.show(destination, sender: nil)
    }
}
