//
//  LoadingRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 19.09.23.
//

import UIKit

@objc protocol LoadingRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol LoadingDataPassing {
    var dataStore: LoadingDataStore? { get }
}

class LoadingRouter: NSObject, LoadingRoutingLogic, LoadingDataPassing {
    
    weak var viewController: LoadingViewController?
    var dataStore: LoadingDataStore?
    
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
    
    //func navigateToSomewhere(source: LoadingViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: LoadingDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
