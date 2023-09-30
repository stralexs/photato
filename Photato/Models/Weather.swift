//
//  Weather.swift
//  Photato
//
//  Created by Alexander Sivko on 29.09.23.
//

import Foundation

struct Weather {
    var timezone: String
    var currentWeather: CurrentWeatherParameters
    var hourlyForecast: [HourlyWeatherParameters]
    var dailyForecast: [DailyWeatherParameters]
}

struct CurrentWeatherParameters {
    let date: String
    let mainStatus: String
    let temp: Double
    let humidity: Int
    let windSpeed: Double
}

struct HourlyWeatherParameters {
    let hour: String
    let temp: Double
    let icon: String
}

struct DailyWeatherParameters {
    let weekday: String
    let tempDay: Double
    let tempNight: Double
    let icon: String
}
