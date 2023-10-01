//
//  WeatherForecastInteractor.swift
//  Photato
//
//  Created by Alexander Sivko on 29.09.23.
//

import UIKit

protocol WeatherForecastBusinessLogic {
    func getLocationName(request: WeatherForecast.GetLocationName.Request)
    func getWeather(request: WeatherForecast.GetWeather.Request)
}

protocol WeatherForecastDataStore {
    var location: Location? { get set }
}

class WeatherForecastInteractor: WeatherForecastBusinessLogic, WeatherForecastDataStore {
    var presenter: WeatherForecastPresentationLogic?
    var location: Location?
    private let weatherManager: WeatherManagerLogic
        
    func getLocationName(request: WeatherForecast.GetLocationName.Request) {
        guard let location = location else { return }
        let response = WeatherForecast.GetLocationName.Response(locationName: location.name)
        presenter?.presentLocationName(response: response)
    }
    
    func getWeather(request: WeatherForecast.GetWeather.Request) {
        guard let latitude = location?.coordinates.latitude,
              let longitude = location?.coordinates.longitude else { return }
        
        weatherManager.getWeather(latittude: String(latitude), longtitude: String(longitude)) { [weak self] result in
            switch result {
            case .success(let weather):
                let response = WeatherForecast.GetWeather.Response(weatherFetchResult: .success(weather))
                self?.presenter?.presentWeather(response: response)
            case .failure(let error):
                let response = WeatherForecast.GetWeather.Response(weatherFetchResult: .failure(error))
                self?.presenter?.presentWeather(response: response)
            }
        }
    }
    
    init(weatherManager: WeatherManagerLogic) {
        self.weatherManager = weatherManager
    }
}