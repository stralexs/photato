//
//  WeatherManager.swift
//  Photato
//
//  Created by Alexander Sivko on 29.09.23.
//

import Foundation
import Alamofire

protocol WeatherManagerLogic {
    func getWeather(latittude: String, longtitude: String, completion: @escaping (Result<Weather, WeatherError>) -> Void)
}

private extension String {
    static let baseURL = "https://api.openweathermap.org/data/3.0/onecall?"
    static let latitudeURL = "lat="
    static let longtitudeURL = "&lon="
    static let keyApi = "&appid=efc102590e9138889b4c5376d0730c86"
    static let units = "&units=metric"
}

enum WeatherError: Error {
    case failedToGetWeatherData
}

final class WeatherManager: WeatherManagerLogic {
    func getWeather(latittude: String, longtitude: String, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        let urlString = .baseURL + .latitudeURL + latittude + .longtitudeURL + longtitude + .keyApi + .units
        
        AF.request(urlString).response { response in
            guard let data = response.data,
                  let JSONSerialization = try? JSONSerialization.jsonObject(with: data),
                  let json = JSONSerialization as? [String: Any],
                  let timezone = json["timezone"] as? String else { completion(.failure(.failedToGetWeatherData)); return }
            
            // MARK: Current weather
            guard let current = json["current"] as? [String: Any] else { completion(.failure(.failedToGetWeatherData)); return }
            
            let time = current["dt"] as? Double
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(identifier: timezone)
            
            let temp = current["temp"] as? Double
            let humidity = current["humidity"] as? Int
            let windSpeed = current["wind_speed"] as? Double
            
            guard let weatherGroup = current["weather"] as? [[String: Any]] else { completion(.failure(.failedToGetWeatherData)); return }
            var mainStatus = String()
            for weather in weatherGroup {
                if let main = weather["main"] as? String {
                    mainStatus = main
                }
            }
            
            guard let time = time,
                  let temp = temp,
                  let humidity = humidity,
                  let windSpeed = windSpeed else { completion(.failure(.failedToGetWeatherData)); return }
            let formattedTime = formatter.string(from: Date(timeIntervalSince1970: time))
            
            let currentWeather = CurrentWeatherParameters(date: formattedTime, mainStatus: mainStatus, temp: temp, humidity: humidity, windSpeed: windSpeed)
            
            // MARK: Hourly weather
            var hourlyWeather = [HourlyWeatherParameters]()
            guard let hourly = json["hourly"] as? [[String: Any]] else { completion(.failure(.failedToGetWeatherData)); return }
            for i in 0...23 {
                let date = hourly[i]["dt"] as? Double
                let formatter = DateFormatter()
                formatter.dateFormat = "HH"
                formatter.timeZone = TimeZone(identifier: timezone)
                
                let temp = hourly[i]["temp"] as? Double
                
                guard let weather = hourly[i]["weather"] as? [[String: Any]] else { completion(.failure(.failedToGetWeatherData)); return }
                let icon = weather.first?["icon"] as? String
                
                guard let date = date,
                      let temp = temp,
                      let icon = icon else { completion(.failure(.failedToGetWeatherData)); return }
                let formattedDate = formatter.string(from: Date(timeIntervalSince1970: date))
                
                let weatherForHour = HourlyWeatherParameters(hour: formattedDate, temp: temp, icon: icon)
                hourlyWeather.append(weatherForHour)
            }
            
            // MARK: Daily weather
            var dailyWeather = [DailyWeatherParameters]()
            guard let daily = json["daily"] as? [[String: Any]] else { completion(.failure(.failedToGetWeatherData)); return }
            for day in daily {
                let date = day["dt"] as? Double
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE"
                formatter.locale = Locale(identifier: "en_US")
                formatter.timeZone = TimeZone(identifier: timezone)
                
                guard let temp = day["temp"] as? [String: Any] else { completion(.failure(.failedToGetWeatherData)); return }
                let tempDay = temp["day"] as? Double
                let tempNight = temp["night"] as? Double
                
                guard let weather = day["weather"] as? [[String: Any]] else { completion(.failure(.failedToGetWeatherData)); return }
                let icon = weather.first?["icon"] as? String
                
                guard let date = date,
                      let tempDay = tempDay,
                      let tempNight = tempNight,
                      let icon = icon else { return }
                let formattedDate = formatter.string(from: Date(timeIntervalSince1970: date))
                
                let weatherForDay = DailyWeatherParameters(weekday: formattedDate, tempDay: tempDay, tempNight: tempNight, icon: icon)
                dailyWeather.append(weatherForDay)
            }
            
            // MARK: Initialization of weather
            let weatherData = Weather(timezone: timezone,
                                      currentWeather: currentWeather,
                                      hourlyForecast: hourlyWeather,
                                      dailyForecast: dailyWeather)
            
            completion(.success(weatherData))
        }
    }
}
