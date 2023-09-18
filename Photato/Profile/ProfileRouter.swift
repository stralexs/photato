//
//  ProfileRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

@objc protocol ProfileRoutingLogic {
    func routeToLocationDescription()
}

protocol ProfileDataPassing {
    var dataStore: ProfileDataStore? { get }
}

final class ProfileRouter: NSObject, ProfileRoutingLogic, ProfileDataPassing {
    weak var viewController: ProfileViewController?
    var dataStore: ProfileDataStore?
    
    // MARK: - Routing
    func routeToLocationDescription() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "LocationDescriptionViewController") as! LocationDescriptionViewController
        var destinationDS = destinationVC.router!.dataStore!
        destinationVC.hidesBottomBarWhenPushed = true
        passDataToLocationDescription(source: dataStore!, destination: &destinationDS)
        navigateToLocationDescription(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    func navigateToLocationDescription(source: ProfileViewController, destination: LocationDescriptionViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: - Passing data
    func passDataToLocationDescription(source: ProfileDataStore, destination: inout LocationDescriptionDataStore) {
        guard let indexPath = viewController?.tableView.indexPathForSelectedRow else { return }
        destination.location = source.locations[indexPath.row]
    }
}
