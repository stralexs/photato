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

class LoadingRouter: NSObject, LoadingRoutingLogic {
    weak var viewController: LoadingViewController?
    
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
        
        guard let navigationController = source.navigationController else { return }
        var navigationArray = navigationController.viewControllers
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!)
        source.navigationController?.viewControllers = navigationArray
    }
}
