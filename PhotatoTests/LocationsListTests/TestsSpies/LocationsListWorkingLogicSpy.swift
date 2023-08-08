//
//  LocationsListWorkingLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 8.08.23.
//

import Foundation
@testable import Photato

final class LocationsListWorkingLogicSpy: LocationsListWorkingLogic {
    private(set) var isCalledFetchLocations = false
    private(set) var isCalledSearchLocations = false
    
    func fetchLocations() -> [Location] {
        isCalledFetchLocations = true
        return []
    }
    
    func searchLocations(using searchText: String) -> [Location] {
        isCalledSearchLocations = true
        return []
    }
}
