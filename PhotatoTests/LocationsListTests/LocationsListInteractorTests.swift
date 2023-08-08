//
//  LocationsListInteractorTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 8.08.23.
//

import XCTest
@testable import Photato

final class LocationsListInteractorTests: XCTestCase {
    private var sut: LocationsListInteractor!
    private var presenter: LocationsListPresentationLogicSpy!
    private var worker: LocationsListWorkingLogicSpy!
    private var location: Location!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let locationsListInteractor = LocationsListInteractor()
        let locationsListPresenter = LocationsListPresentationLogicSpy()
        let locationsListWorker = LocationsListWorkingLogicSpy()
        
        locationsListInteractor.presenter = locationsListPresenter
        locationsListInteractor.worker = locationsListWorker
            
        sut = locationsListInteractor
        presenter = locationsListPresenter
        worker = locationsListWorker
        
        location = Location(name: "Foo", description: "Bar", address: "Baz", coordinates: Location.Coordinates(longitude: 0.0, latitude: 0.0), imagesData: [Data()])
    }

    override func tearDownWithError() throws {
        sut = nil
        presenter = nil
        worker = nil
        try super.tearDownWithError()
    }
    
    func testSutIsNotNil() {
        XCTAssertNotNil(sut)
    }
    
    func testIsCalledPresentLocations() {
        let request = LocationsList.FetchLocations.Request()
        sut.locations = [location]
        sut.fetchLocations(request: request)
        
        XCTAssertTrue(presenter.isCalledPresentLocations)
        XCTAssertTrue(worker.isCalledFetchLocations)
    }
    
    func testIsCalledPresentSearchedLocations() {
        let request = LocationsList.SearchLocations.Request(searchText: "Foo")
        sut.locations = [location]
        sut.searchLocations(request: request)
        
        XCTAssertTrue(presenter.isCalledPresentSearchedLocations)
        XCTAssertTrue(worker.isCalledSearchLocations)
    }
}
