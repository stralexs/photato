//
//  CurrentLocationWeather.swift
//  Photato
//
//  Created by Alexander Sivko on 3.01.24.
//

import SwiftUI

struct CurrentLocationWeather: View {
    private let locationNameFontSize: CGFloat = 90
    private let hStackSpacing: CGFloat = 15
    private let vStackSpacing: CGFloat = 35
    private let frameSize: CGFloat = 40
    
    let currentWeather: WeatherForecastViewModel.CurrentWeatherModel
    
    var body: some View {
        HStack(spacing: hStackSpacing) {
            VStack {
                Text(currentWeather.currentTemp)
                    .font(.system(size: locationNameFontSize))
                    .fontWeight(.thin)
                Text(currentWeather.currentStatus)
                    .font(.title2)
            }
            .padding()
            VStack(alignment: .leading, spacing: vStackSpacing) {
                HStack {
                    Image(systemName: "humidity")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: frameSize, height: frameSize)
                    Text(currentWeather.humidity)
                }
                HStack {
                    Image(systemName: "wind")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: frameSize, height: frameSize)
                    Text(currentWeather.windSpeed)
                }
            }
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    let currentWeather = WeatherForecastViewModel.CurrentWeatherModel(currentTemp: "12°", currentStatus: "Sunny", humidity: "76%", windSpeed: "3.4 m/s")
    return CurrentLocationWeather(currentWeather: currentWeather)
}
