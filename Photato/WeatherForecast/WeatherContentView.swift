//
//  WeatherForecastView.swift
//  Photato
//
//  Created by Alexander Sivko on 21.12.23.
//

import SwiftUI

struct WeatherContentView: View {
    private let vStackSpacing: CGFloat = 0
    @Environment(WeatherForecastViewModel.self) private var viewModel: WeatherForecastViewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: vStackSpacing) {
            LocationNameTitleView(locationName: viewModel.locationName ?? "")
            ZStack {
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    LocationWeatherView()
                }
            }
        }
        .alert("Failed to load weather data. Please try again later.",
               isPresented: $viewModel.isErrorOccured,
               presenting: viewModel.errorDescription) { _ in
            Button("Ok") {}
        } message: { errorDescription in
            Text(errorDescription)
        }
    }
}

#Preview {
    let dummyLocation = Location(name: "Foo",
                                 description: "Bar",
                                 address: "Baz",
                                 coordinates: Location.Coordinates(latitude: 53.98, longitude: 27.57),
                                 imagesData: [])
    return WeatherContentView()
        .environment(WeatherForecastViewModel(dummyLocation))
}
