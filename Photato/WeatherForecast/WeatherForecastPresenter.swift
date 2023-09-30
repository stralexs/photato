//
//  WeatherForecastPresenter.swift
//  Photato
//
//  Created by Alexander Sivko on 29.09.23.
//

import UIKit

protocol WeatherForecastPresentationLogic {
    func presentLocationName(response: WeatherForecast.GetLocationName.Response)
    func presentWeather(response: WeatherForecast.GetWeather.Response)
}

class WeatherForecastPresenter: WeatherForecastPresentationLogic {
    weak var viewController: WeatherForecastDisplayLogic?
        
    func presentLocationName(response: WeatherForecast.GetLocationName.Response) {
        let viewModel = WeatherForecast.GetLocationName.ViewModel(locationName: response.locationName)
        viewController?.displayLocationName(viewModel: viewModel)
    }
    
    func presentWeather(response: WeatherForecast.GetWeather.Response) {
        switch response.weatherFetchResult {
        case .success(let weather):
            let temperature = "\(Int(round(weather.currentWeather.temp)))°"
            let mainStatus = "\(weather.currentWeather.mainStatus)"
            let humidity = "\(weather.currentWeather.humidity)%"
            let windSpeed = "\(weather.currentWeather.windSpeed) m/s"
            
            let viewModel = WeatherForecast.GetWeather.ViewModel(errorDescription: nil,
                                                                 currentWeatherDetails: (temperature, mainStatus, humidity, windSpeed),
                                                                 hourlyForecast: weather.hourlyForecast,
                                                                 dailyForecast: weather.dailyForecast)
            viewController?.displayWeather(viewModel: viewModel)
        case .failure(let error):
            switch error {
            case .failedToGetWeatherData:
                let viewModel = WeatherForecast.GetWeather.ViewModel(errorDescription: "Failed to load weather data. Please try again later",
                                                                     currentWeatherDetails: nil,
                                                                     hourlyForecast: nil,
                                                                     dailyForecast: nil)
                viewController?.displayWeather(viewModel: viewModel)
            }
        }
    }
}
