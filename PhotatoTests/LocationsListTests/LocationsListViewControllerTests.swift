//
//  LocationsListViewControllerTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 7.08.23.
//

import XCTest
@testable import Photato

final class LocationsListViewControllerTests: XCTestCase {
    private var sut: LocationsListViewController!
    private var interactor: LocationsListBusinessLogicSpy!
    private var location1: Location!
    private var location2: Location!
    private var locations: [Location]!
    private var tableViewSpy: LocationsListTableViewSpy!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let locationsListViewController = storyboard.instantiateViewController(identifier: "LocationsListViewController") as? LocationsListViewController
        let locationsListInteractor = LocationsListBusinessLogicSpy()
            
        locationsListViewController?.interactor = locationsListInteractor
        interactor = locationsListInteractor

        sut = locationsListViewController
        interactor = locationsListInteractor
        tableViewSpy = LocationsListTableViewSpy()
        location1 = Location(name: "Foo", description: "Bar", address: "Baz", coordinates: Location.Coordinates(longitude: 0.0, latitude: 0.0), imagesData: [Data()])
        location2 = Location(name: "Baz", description: "Foo", address: "Bar", coordinates: Location.Coordinates(longitude: 0.0, latitude: 0.0), imagesData: [Data()])
        locations = [location1, location2]

        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        interactor = nil
        try super.tearDownWithError()
    }
    
    func testSutIsNotNil() {
        XCTAssertNotNil(sut)
    }
    
    func testIsCalledFetchLocations() {
        let request = LocationsList.FetchLocations.Request()
        interactor?.fetchLocations(request: request)
        XCTAssertTrue(interactor.isCalledFetchLocations)
    }
    
    func testIsCalledSearchLocations() {
        let request = LocationsList.SearchLocations.Request(searchText: "Foo")
        interactor.searchLocations(request: request)
        XCTAssertTrue(interactor.isCalledSearchLocations)
    }
      
    func testTableViewDisplaysFetchedLocations() {
        let viewModel = LocationsList.FetchLocations.ViewModel(locations: locations)
          
        sut.tableView = tableViewSpy
        tableViewSpy.dataSource = sut
        sut.displayLocations(viewModel: viewModel)
          
        XCTAssertTrue(tableViewSpy.isCalledReloadData)
        XCTAssertEqual(tableViewSpy.numberOfRows(inSection: 0), locations.count)
    }
    
    func testTableViewDisplaysSearchedLocations() {
        let viewModel = LocationsList.SearchLocations.ViewModel(locations: locations)
          
        sut.tableView = tableViewSpy
        tableViewSpy.dataSource = sut
        sut.displaySearchedLocations(viewModel: viewModel)
          
        XCTAssertTrue(tableViewSpy.isCalledReloadData)
        XCTAssertEqual(tableViewSpy.numberOfRows(inSection: 0), locations.count)
    }
    
    func testCancelButtonReloadsTableView() {
        let tableViewSpy = LocationsListTableViewSpy()
        sut.tableView = tableViewSpy
        sut.searchBarCancelButtonClicked(sut.searchController.searchBar)
        XCTAssertTrue(tableViewSpy.isCalledReloadData)
    }
}
