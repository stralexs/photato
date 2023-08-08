//
//  LocationsListDisplayLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 7.08.23.
//

import XCTest
@testable import Photato

final class LocationsListDisplayLogicSpy: LocationsListDisplayLogic {
    private(set) var isCalledDisplayFetchedLocations = false
    private(set) var isCalledDisplaySearchedLocations = false
    private(set) var locations: [Location] = []
    
    func displayLocations(viewModel: LocationsList.FetchLocations.ViewModel) {
        isCalledDisplayFetchedLocations = true
        locations = viewModel.locations
    }
    
    func displaySearchedLocations(viewModel: LocationsList.SearchLocations.ViewModel) {
        isCalledDisplaySearchedLocations = true
        locations = viewModel.locations
    }
}
