//
//  LocationDescriptionRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import SwiftUI

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
        guard let location = dataStore?.location,
              let viewController = viewController else { return }
        let contentView = WeatherContentView()
            .environment(WeatherForecastViewModel(location))
        let hostingController = UIHostingController(rootView: contentView)
        navigateToWeatherForecast(source: viewController, destination: hostingController)
    }
    
    // MARK: - Navigation
    private func navigateToWeatherForecast(source: LocationDescriptionViewController, destination: UIHostingController<some View>) {
        source.present(destination, animated: true)
    }
}
