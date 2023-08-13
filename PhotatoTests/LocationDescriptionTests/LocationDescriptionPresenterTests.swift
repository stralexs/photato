//
//  LocationDescriptionPresenterTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 13.08.23.
//

import XCTest
@testable import Photato

final class LocationDescriptionPresenterTests: XCTestCase {
    private var sut: LocationDescriptionPresenter!
    private var viewController: LocationDescriptionDisplayLogicSpy!
    private var location: Location!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let locationDescriptionPresenter = LocationDescriptionPresenter()
        let locationDescriptionViewController = LocationDescriptionDisplayLogicSpy()
        
        locationDescriptionPresenter.viewController = locationDescriptionViewController
        
        sut = locationDescriptionPresenter
        viewController = locationDescriptionViewController
        
        location = Location(name: "Foo", description: "Bar", address: "Baz", coordinates: Location.Coordinates(latitude: 11.111111111, longitude: 11.11111111), imagesData: [Data()])
    }

    override func tearDownWithError() throws {
        sut = nil
        viewController = nil
        try super.tearDownWithError()
    }
    
    func testSutIsNotNil() {
        XCTAssertNotNil(sut)
    }
    
    func testIsCalledPresentLocationDescription() {
        let response = LocationDescription.ShowLocationDescription.Response(location: location)
        sut.presentLocationDescription(response: response)
        
        XCTAssertTrue(viewController.isCalledDisplayLocationDescription)
    }
    
    func testIsCalledPresentCopiedToClipboardMessage() {
        let response = LocationDescription.CopyCoordinatesToClipboard.Response()
        sut.presentCopiedToClipboardMessage(response: response)
        
        XCTAssertTrue(viewController.isCalledDisplayCopiedToClipboardMessage)
    }
    
    func testPresenterFormatesLocationCoordinatesCorrectly() {
        let response = LocationDescription.ShowLocationDescription.Response(location: location)
        sut.presentLocationDescription(response: response)
        let expectedCoordinates = "11.11111, 11.11111"
        
        XCTAssertEqual(viewController.locationCoordinatesLabel.text, expectedCoordinates)
    }
}
