//
//  Weather.swift
//  Photato
//
//  Created by Alexander Sivko on 29.09.23.
//

import Foundation

struct Weather: Decodable {
    let timezone: String
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    
    struct Current: Decodable {
        let temp: Double
        let humidity: Double
        let windSpeed: Double
        let weather: [WeatherStatus]
    }
    
    struct Hourly: Decodable {
        let dt: Double
        let temp: Double
        let weather: [WeatherStatus]
    }
    
    struct Daily: Decodable {
        let dt: Double
        let temp: Temp
        let weather: [WeatherStatus]
    }
    
    struct WeatherStatus: Decodable {
        let main: String
        let icon: String
    }
    
    struct Temp: Decodable {
        let day: Double
        let night: Double
    }
    
    func prefixHourlyWeather() -> Self {
        let prefixedHourlyWeather = Array(hourly.prefix(24))
        return .init(timezone: timezone,
                     current: current,
                     hourly: prefixedHourlyWeather,
                     daily: daily)
    }
}
