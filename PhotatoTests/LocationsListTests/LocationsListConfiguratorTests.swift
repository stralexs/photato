//
//  LocationsListConfiguratorTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 6.08.23.
//

import XCTest
@testable import Photato

final class LocationsListConfiguratorTests: XCTestCase {
    
    var sut: LocationsListConfigurator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LocationsListConfigurator()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testLocationsListViewControllerIsConfigured() {
        let viewController = LocationsListViewController()
        sut.configure(with: viewController)
        XCTAssertTrue(viewController.interactor is LocationsListInteractor)
        XCTAssertTrue(viewController.router is LocationsListRouter)
    }
}
