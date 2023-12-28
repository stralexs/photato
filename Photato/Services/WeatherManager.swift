//
//  WeatherManager.swift
//  Photato
//
//  Created by Alexander Sivko on 29.09.23.
//

import Foundation
import Alamofire

protocol WeatherManagerLogic {
    func getWeather(latittude: String, longtitude: String) async throws -> Weather
}

private extension String {
    static let baseURL = "https://api.openweathermap.org/data/3.0/onecall?"
    static let latitudeURL = "lat="
    static let longtitudeURL = "&lon="
    static let keyApi = "&appid=efc102590e9138889b4c5376d0730c86"
    static let units = "&units=metric"
}

final class WeatherManager: WeatherManagerLogic, AlamofireDownloadable {
    typealias DecodableModel = Weather
    
    func getWeather(latittude: String, longtitude: String) async throws -> Weather {
        let urlString = .baseURL + .latitudeURL + latittude + .longtitudeURL + longtitude + .keyApi + .units
        let weather = try await getData(urlString).prefixHourlyWeather()
        return weather
    }
}
