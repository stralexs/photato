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

protocol LoginDataPassing {
    var dataStore: LoginDataStore? { get }
}

final class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing {
    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?
    
    func routeToTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//        passDataToLocationDescription(source: dataStore!, destination: &destinationDS)
        navigateToTabBarController(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    private func navigateToTabBarController(source: LoginViewController, destination: TabBarController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: - Passing data
//    func passDataToLocationDescription(source: LocationsListDataStore, destination: inout LocationDescriptionDataStore) {
//        guard let indexPath = viewController?.tableView.indexPathForSelectedRow else { return }
//        destination.location = source.locations[indexPath.row]
//    }
}
