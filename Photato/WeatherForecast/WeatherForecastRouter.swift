//
//  WeatherForecastRouter.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol WeatherForecastDataPassing {
    var dataStore: WeatherForecastDataStore? { get }
}

final class WeatherForecastRouter: NSObject, WeatherForecastDataPassing {
    weak var viewController: WeatherForecastViewController?
    var dataStore: WeatherForecastDataStore?
}
