//
//  UserValidationRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit

@objc protocol UserValidationRoutingLogic {
    func routeToLogin()
    func routeToSignUp()
}

class UserValidationRouter: NSObject, UserValidationRoutingLogic {
    weak var viewController: UserValidationViewController?
    
    // MARK: - Routing
    func routeToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        destinationVC.hidesBottomBarWhenPushed = true
        navigateToLogin(source: viewController!, destination: destinationVC)
    }
    
    func routeToSignUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        destinationVC.hidesBottomBarWhenPushed = true
        navigateToSignUp(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    private func navigateToLogin(source: UserValidationViewController, destination: LoginViewController) {
        source.show(destination, sender: nil)
    }
    
    private func navigateToSignUp(source: UserValidationViewController, destination: SignUpViewController) {
        source.show(destination, sender: nil)
    }
}
