//
//  MapRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

@objc protocol MapRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol MapDataPassing {
    var dataStore: MapDataStore? { get }
}

class MapRouter: NSObject, MapRoutingLogic, MapDataPassing {
    
    weak var viewController: MapViewController?
    var dataStore: MapDataStore?
    
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
    
    //func navigateToSomewhere(source: MapViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: MapDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
