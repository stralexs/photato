//
//  LocationsListPresenterTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 8.08.23.
//

import XCTest
@testable import Photato

final class LocationsListPresenterTests: XCTestCase {
    private var sut: LocationsListPresenter!
    private var viewController: LocationsListDisplayLogicSpy!
    private var location1: Location!
    private var location2: Location!
    private var locations: [Location]!
    private var expectationFirstName = "Baz"
    private var expectationLastName = "Foo"

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let locationsListPresenter = LocationsListPresenter()
        let locationsListViewController = LocationsListDisplayLogicSpy()
            
        locationsListPresenter.viewController = locationsListViewController
            
        sut = locationsListPresenter
        viewController = locationsListViewController
        
        location1 = Location(name: "Foo", description: "Bar", address: "Baz", coordinates: Location.Coordinates(latitude: 0.0, longitude: 0.0), imagesData: [Data()])
        location2 = Location(name: "Baz", description: "Foo", address: "Bar", coordinates: Location.Coordinates(latitude: 0.0, longitude: 0.0), imagesData: [Data()])
        locations = [location1, location2]
    }

    override func tearDownWithError() throws {
        sut = nil
        viewController = nil
        try super.tearDownWithError()
    }
    
    func testSutIsNotNil() {
        XCTAssertNotNil(sut)
    }
    
    func testIsCalledDisplayLocations() {
        let response = LocationsList.FetchLocations.Response(locations: locations)
        
        sut.presentLocations(response: response)
        
        XCTAssertTrue(viewController.isCalledDisplayFetchedLocations)
        XCTAssertEqual(viewController.locations.first?.name, expectationFirstName)
        XCTAssertEqual(viewController.locations.last?.name, expectationLastName)
    }
    
    func testIsCalledDisplaySearchedLocations() {
        let response = LocationsList.SearchLocations.Response(locations: locations)
        
        sut.presentSearchedLocations(response: response)
        
        XCTAssertTrue(viewController.isCalledDisplaySearchedLocations)
        XCTAssertEqual(viewController.locations.first?.name, expectationFirstName)
        XCTAssertEqual(viewController.locations.last?.name, expectationLastName)
    }
}
