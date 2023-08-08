//
//  LocationsListPresentationLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 8.08.23.
//

import Foundation
@testable import Photato

final class LocationsListPresentationLogicSpy: LocationsListPresentationLogic {
    private(set) var isCalledPresentLocations = false
    private(set) var isCalledPresentSearchedLocations = false
    
    func presentLocations(response: Photato.LocationsList.FetchLocations.Response) {
        isCalledPresentLocations = true
    }
    
    func presentSearchedLocations(response: Photato.LocationsList.SearchLocations.Response) {
        isCalledPresentSearchedLocations = true
    }
}
