//
//  LoginRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

@objc protocol LoginRoutingLogic {
    func routeToTabBarController()
}

final class LoginRouter: NSObject, LoginRoutingLogic {
    weak var viewController: LoginViewController?
    
    func routeToTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        navigateToTabBarController(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    private func navigateToTabBarController(source: LoginViewController, destination: TabBarController) {
        source.show(destination, sender: nil)
    }
}
