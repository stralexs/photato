//
//  DailyForecastItem.swift
//  Photato
//
//  Created by Alexander Sivko on 3.01.24.
//

import SwiftUI

struct DailyForecastItem: View {
    private let weekdayFrameWidth: CGFloat = 90
    private let imageFrameSize: CGFloat = 40
    private let dayWeatherFrameWidth: CGFloat = 100
    private let nightWeatherFrameWidth: CGFloat = 90
    
    let dailyWeather: WeatherForecastViewModel.DailyForecastItemModel
    
    var body: some View {
        HStack {
            Text(dailyWeather.weekday)
                .font(.callout.weight(.medium))
                .frame(width: weekdayFrameWidth, alignment: .leading)
            Image(uiImage: dailyWeather.image)
                .resizable()
                .frame(width: imageFrameSize, height: imageFrameSize)
            Text(dailyWeather.nightTemp)
                .font(.callout.weight(.medium))
                .frame(width: dayWeatherFrameWidth, alignment: .leading)
            Text(dailyWeather.dayTemp)
                .font(.callout.weight(.medium))
                .frame(width: nightWeatherFrameWidth, alignment: .leading)
        }
        .foregroundStyle(Color(uiColor: .darkOliveGreen))
        .listRowBackground(Color(uiColor: .lightTortilla))
    }
}

#Preview {
    let dailyWeather = WeatherForecastViewModel.DailyForecastItemModel(weekday: "Wednsday", image: UIImage(named: "01d")!, dayTemp: "Day: 24°", nightTemp: "Night: 10°")
    return DailyForecastItem(dailyWeather: dailyWeather)
}
