//
//  LocationsListBusinessLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 7.08.23.
//

import Foundation
@testable import Photato

final class LocationsListBusinessLogicSpy: LocationsListBusinessLogic {
    private(set) var isCalledFetchLocations = false
    private(set) var isCalledSearchLocations = false
    
    func fetchLocations(request: LocationsList.FetchLocations.Request) {
        isCalledFetchLocations = true
    }
    
    func searchLocations(request: LocationsList.SearchLocations.Request) {
        isCalledSearchLocations = true
    }
}
