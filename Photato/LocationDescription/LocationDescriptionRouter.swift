//
//  LocationDescriptionRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

@objc protocol LocationDescriptionRoutingLogic {
    func routeToWeatherForecast()
}

protocol LocationDescriptionDataPassing {
    var dataStore: LocationDescriptionDataStore? { get }
}

final class LocationDescriptionRouter: NSObject, LocationDescriptionRoutingLogic, LocationDescriptionDataPassing {
    weak var viewController: LocationDescriptionViewController?
    var dataStore: LocationDescriptionDataStore?
    
    // MARK: - Routing
    func routeToWeatherForecast() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "WeatherForecastViewController") as! WeatherForecastViewController
        var destinationDS = destinationVC.router!.dataStore!
        destinationVC.hidesBottomBarWhenPushed = true
        passDataToWeatherForecast(source: dataStore!, destination: &destinationDS)
        navigateToWeatherForecast(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    func navigateToWeatherForecast(source: LocationDescriptionViewController, destination: WeatherForecastViewController) {
        source.present(destination, animated: true)
    }
    
    // MARK: - Passing data
    func passDataToWeatherForecast(source: LocationDescriptionDataStore, destination: inout WeatherForecastDataStore) {
        destination.location = source.location
    }
}
