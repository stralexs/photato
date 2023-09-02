//
//  MapRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

@objc protocol MapRoutingLogic {
    func routeToLocationDescription(with name: String?)
}

protocol MapDataPassing {
    var dataStore: MapDataStore? { get }
}

class MapRouter: NSObject, MapRoutingLogic, MapDataPassing {
    weak var viewController: MapViewController?
    var dataStore: MapDataStore?
    
    // MARK: - Routing
    func routeToLocationDescription(with name: String?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "LocationDescriptionViewController") as! LocationDescriptionViewController
        var destinationDS = destinationVC.router!.dataStore!
        destinationVC.hidesBottomBarWhenPushed = true
        passDataToLocationDescription(source: dataStore!, destination: &destinationDS, name: name)
        navigateToLocationDescription(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    func navigateToLocationDescription(source: MapViewController, destination: LocationDescriptionViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: - Passing data
    func passDataToLocationDescription(source: MapDataStore, destination: inout LocationDescriptionDataStore, name: String?) {
        guard let name = name else { return }
        
        destination.location = source.locations.first(where: { $0.name == name })
    }
}
