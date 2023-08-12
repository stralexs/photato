//
//  LocationsListRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

@objc protocol LocationsListRoutingLogic {
    func routeToLocationDescription()
}

protocol LocationsListDataPassing {
    var dataStore: LocationsListDataStore? { get }
}

class LocationsListRouter: NSObject, LocationsListRoutingLogic, LocationsListDataPassing {
    weak var viewController: LocationsListViewController?
    var dataStore: LocationsListDataStore?
    
    // MARK: - Routing
    func routeToLocationDescription() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "LocationDescriptionViewController") as! LocationDescriptionViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToLocationDescription(source: dataStore!, destination: &destinationDS)
        navigateToLocationDescription(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    func navigateToLocationDescription(source: LocationsListViewController, destination: LocationDescriptionViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: - Passing data
    func passDataToLocationDescription(source: LocationsListDataStore, destination: inout LocationDescriptionDataStore) {
        guard let indexPath = viewController?.tableView.indexPathForSelectedRow else { return }
        destination.location = source.locations[indexPath.row]
    }
}
