//
//  LocationsListRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

@objc protocol LocationsListRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol LocationsListDataPassing {
    var dataStore: LocationsListDataStore? { get }
}

class LocationsListRouter: NSObject, LocationsListRoutingLogic, LocationsListDataPassing {
    
    weak var viewController: LocationsListViewController?
    var dataStore: LocationsListDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?) {
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: LocationsListViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: LocationsListDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
