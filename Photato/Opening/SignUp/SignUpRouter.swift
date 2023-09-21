//
//  SignUpRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 18.09.23.
//

import UIKit

@objc protocol SignUpRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol SignUpDataPassing {
    var dataStore: SignUpDataStore? { get }
}

final class SignUpRouter: NSObject, SignUpRoutingLogic, SignUpDataPassing {
    
    weak var viewController: SignUpViewController?
    var dataStore: SignUpDataStore?
    
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
    
    //func navigateToSomewhere(source: SignUpViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: SignUpDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
