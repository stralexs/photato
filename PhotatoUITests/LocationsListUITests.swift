//
//  PhotatoUITests.swift
//  PhotatoUITests
//
//  Created by Alexander Sivko on 5.08.23.
//

import XCTest
@testable import Photato

final class LocationsListUITests: XCTestCase {
    private let app = XCUIApplication()
    private var locationsListTabBarButton: XCUIElement!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        locationsListTabBarButton = app.tabBars["Tab Bar"].buttons["Карта"]
    }
    
    func testLocationsListTabBarButtonExists() {
        XCTAssertTrue(locationsListTabBarButton.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
