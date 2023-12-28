//
//  WeatherForecastModels.swift
//  Photato
//
//  Created by Alexander Sivko on 29.09.23.
//

import UIKit

enum WeatherForecast {
    enum GetLocationName {
        struct Request {}
        
        struct Response {
            let locationName: String
        }
        
        struct ViewModel {
            let locationName: String
        }
    }
    
    enum GetWeather {
        struct Request {}
        
        struct Response {
            let weatherFetchResult: Result<Weather, Error>
        }
        
        struct ViewModel {
            let errorDescription: String?
            let currentWeatherDetails: (temperature: String, mainStatus: String, humidity: String, windSpeed: String)?
            let hourlyForecast: [Weather.Hourly]?
            let dailyForecast: [Weather.Daily]?
        }
    }
}
