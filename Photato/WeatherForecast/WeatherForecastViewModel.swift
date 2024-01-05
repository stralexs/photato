//
//  WeatherForecastViewModel.swift
//  Photato
//
//  Created by Alexander Sivko on 28.12.23.
//

import UIKit
import OSLog

@Observable
final class WeatherForecastViewModel {
    private let weatherManager: WeatherManagerLogic = WeatherManager()
    private let dateFormatter = DateFormatter()
    private let logger = Logger()
    
    var hourlyForecastItems = [HourlyForecastItemModel]()
    var dailyForecastItems = [DailyForecastItemModel]()
    var currentWeatherModel: CurrentWeatherModel?
    var isLoading = true
    var isErrorOccured = false
    var errorDescription: String?
    var locationName: String?
    
    struct CurrentWeatherModel {
        let currentTemp: String
        let currentStatus: String
        let humidity: String
        let windSpeed: String
    }
    
    struct HourlyForecastItemModel {
        var hour: String
        let image: UIImage
        let temp: String
    }
    
    struct DailyForecastItemModel {
        var weekday: String
        let image: UIImage
        let dayTemp: String
        let nightTemp: String
    }
    
    init(_ location: Location) {
        locationName = location.name
        fetchWeather(latitude: String(location.coordinates.latitude),
                     longitude: String(location.coordinates.longitude))
    }
}

extension WeatherForecastViewModel {
    private func fetchWeather(latitude: String, longitude: String) {
        Task {
            do {
                let weather = try await weatherManager.getWeather(latittude: latitude,
                                                                  longtitude: longitude)
                await MainActor.run {
                    dateFormatter.timeZone = TimeZone(identifier: weather.timezone)
                    hourlyForecastItems = weather.hourly.map { convertToHourlyForecast($0) }
                    hourlyForecastItems[0].hour = "Now"
                    dailyForecastItems = weather.daily.map { convertToDailyForecast($0) }
                    dailyForecastItems[0].weekday = "Today"
                    currentWeatherModel = convertToCurrentWeather(weather.current)
                    isLoading = false
                }
            }
            catch {
                isLoading = false
                isErrorOccured = true
                logger.error("\(error.localizedDescription)")
                errorDescription = """
                                    Error description:
                                    \(error.localizedDescription)
                                    """
            }
        }
    }
    
    private func convertToHourlyForecast(_ weather: Weather.Hourly) -> HourlyForecastItemModel {
        dateFormatter.dateFormat = "HH"
        let hour = dateFormatter.string(from: Date(timeIntervalSince1970: weather.dt))
        
        let uiImage: UIImage
        if let image = UIImage(named: weather.weather.first!.icon) {
            uiImage = image
        } else {
            uiImage = UIImage()
        }
        
        let temp = "\(Int(round(weather.temp)))°"
        
        return HourlyForecastItemModel(hour: hour, image: uiImage, temp: temp)
    }
    
    private func convertToDailyForecast(_ weather: Weather.Daily) -> DailyForecastItemModel {
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_US")
        let weekday = dateFormatter.string(from: Date(timeIntervalSince1970: weather.dt))
        
        let uiImage: UIImage
        if let image = UIImage(named: weather.weather.first!.icon) {
            uiImage = image
        } else {
            uiImage = UIImage()
        }
        
        let dayTemp = "Day: \(Int(round(weather.temp.day)))°"
        let nightTemp = "Night: \(Int(round(weather.temp.night)))°"
        
        return DailyForecastItemModel(weekday: weekday, image: uiImage, dayTemp: dayTemp, nightTemp: nightTemp)
    }
    
    private func convertToCurrentWeather(_ weather: Weather.Current) -> CurrentWeatherModel {
        return CurrentWeatherModel(currentTemp: "\(Int(round(weather.temp)))°",
                                   currentStatus: "\(weather.weather.first!.main)",
                                   humidity: "\(Int(weather.humidity))%",
                                   windSpeed: "\(weather.windSpeed) m/s")
    }
}
