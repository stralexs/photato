//
//  SettingsRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 27.09.23.
//

import UIKit

@objc protocol SettingsRoutingLogic {
    func routeToUserValidation()
    func routeToProfile(navigationController: UINavigationController?)
}

class SettingsRouter: NSObject, SettingsRoutingLogic {
    weak var viewController: SettingsViewController?
    
    // MARK: - Routing
    func routeToUserValidation() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "UserValidationViewController") as! UserValidationViewController
        navigateToUserValidation(source: viewController!, destination: destinationVC)
    }
    
    func routeToProfile(navigationController: UINavigationController?) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    private func navigateToUserValidation(source: SettingsViewController, destination: UserValidationViewController) {
        source.show(destination, sender: nil)
    }
}
