//
//  LoadingRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit

@objc protocol LoadingRoutingLogic {
    func routeToUserValidation()
    func routeToTabBarController()
}

protocol LoadingDataPassing {
    var dataStore: LoadingDataStore? { get }
}

class LoadingRouter: NSObject, LoadingRoutingLogic, LoadingDataPassing {
    weak var viewController: LoadingViewController?
    var dataStore: LoadingDataStore?
    
    func routeToUserValidation() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "UserValidationViewController") as! UserValidationViewController
        navigateToUserValidation(source: viewController!, destination: destinationVC)
    }
    
    func routeToTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        navigateToTabBarController(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    private func navigateToUserValidation(source: LoadingViewController, destination: UserValidationViewController) {
        source.show(destination, sender: nil)
    }
    
    private func navigateToTabBarController(source: LoadingViewController, destination: TabBarController) {
        source.show(destination, sender: nil)
    }
}
