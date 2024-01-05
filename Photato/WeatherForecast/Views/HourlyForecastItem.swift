//
//  HourlyForecastItem.swift
//  Photato
//
//  Created by Alexander Sivko on 3.01.24.
//

import SwiftUI

struct HourlyForecastItem: View {
    private let imageFrameSize: CGFloat = 35
    private let vStackPadding: CGFloat = 10
    
    let hourlyWeather: WeatherForecastViewModel.HourlyForecastItemModel
    
    var body: some View {
        VStack {
            Text(hourlyWeather.hour)
                .foregroundStyle(.primary)
                .font(.callout.weight(.medium))
            Image(uiImage: hourlyWeather.image)
                .resizable()
                .frame(width: imageFrameSize, height: imageFrameSize)
            Text(hourlyWeather.temp)
                .foregroundStyle(.primary)
                .font(.callout.weight(.medium))
        }
        .foregroundStyle(Color(uiColor: .darkOliveGreen))
        .padding(vStackPadding)
    }
}

#Preview {
    let hourlyForecast = WeatherForecastViewModel.HourlyForecastItemModel(hour: "12", image: UIImage(named: "01d")!, temp: "24°")
    return HourlyForecastItem(hourlyWeather: hourlyForecast)
}
