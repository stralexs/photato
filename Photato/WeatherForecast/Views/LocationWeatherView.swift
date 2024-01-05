//
//  LocationWeatherView.swift
//  Photato
//
//  Created by Alexander Sivko on 4.01.24.
//

import SwiftUI

struct LocationWeatherView: View {
    private let vStackSpacing: CGFloat = 20
    private let currentWeatherFrameAspectRatio: Double = 0.25
    private let hourlyForecastFrameAspectRatio: Double = 0.16
    private let roundedRectangleCornerRadius: CGFloat = 15
    
    @Environment(WeatherForecastViewModel.self) private var viewModel: WeatherForecastViewModel
    
    var body: some View {
        GeometryReader { metrics in
            Color(uiColor: .tortilla)
                .ignoresSafeArea()
            VStack(spacing: vStackSpacing) {
                if let current = viewModel.currentWeatherModel {
                    CurrentLocationWeather(currentWeather: current)
                        .frame(height: metrics.size.height * currentWeatherFrameAspectRatio)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.hourlyForecastItems, id: \.hour) { weather in
                            HourlyForecastItem(hourlyWeather: weather)
                        }
                    }
                }
                .frame(height: metrics.size.height * hourlyForecastFrameAspectRatio)
                .background(Color(uiColor: .lightTortilla))
                .clipShape(RoundedRectangle(cornerRadius: roundedRectangleCornerRadius))
                
                List(viewModel.dailyForecastItems, id: \.weekday) { weather in
                    DailyForecastItem(dailyWeather: weather)
                }
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .background(Color(uiColor: .lightTortilla))
                .listStyle(PlainListStyle())
                .clipShape(RoundedRectangle(cornerRadius: roundedRectangleCornerRadius))
            }
            .padding()
        }
    }
}

#Preview {
    let dummyLocation = Location(name: "Foo",
                                 description: "Bar",
                                 address: "Baz",
                                 coordinates: Location.Coordinates(latitude: 53.98, longitude: 27.57),
                                 imagesData: [])
    return LocationWeatherView()
        .environment(WeatherForecastViewModel(dummyLocation))
}
