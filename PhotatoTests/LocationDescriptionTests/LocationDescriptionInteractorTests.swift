//
//  LocationDescriptionInteractorTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 13.08.23.
//

import XCTest
@testable import Photato

final class LocationDescriptionInteractorTests: XCTestCase {
    private var sut: LocationDescriptionInteractor!
    private var presenter: LocationDescriptionPresentationLogicSpy!
    private var worker: LocationDescriptionWorkingLogicSpy!
    private var location: Location!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let locationDescriptionWorker = LocationDescriptionWorkingLogicSpy()
        let locationDescriptionInteractor = LocationDescriptionInteractor(worker: locationDescriptionWorker)
        let locationDescriptionPresenter = LocationDescriptionPresentationLogicSpy()
        
        locationDescriptionInteractor.presenter = locationDescriptionPresenter
            
        sut = locationDescriptionInteractor
        presenter = locationDescriptionPresenter
        worker = locationDescriptionWorker
        
        location = Location(name: "Foo", description: "Bar", address: "Baz", coordinates: Location.Coordinates(latitude: 1.1, longitude: 2.2), imagesData: [Data()])
        sut.location = location
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
    
    func testIsCalledPresentLocationDescription() {
        let request = LocationDescription.ShowLocationDescription.Request()
        sut.showLocationDescription(request: request)
        
        XCTAssertTrue(presenter.isCalledPresentLocationDescription)
    }
    
    func testIsCalledPresentCopiedToClipboardMessage() {
        let request = LocationDescription.CopyCoordinatesToClipboard.Request()
        sut.copyCoordinatesToClipboard(request: request)
        
        XCTAssertTrue(presenter.isCalledPresentCopiedToClipboardMessage)
    }
    
    func testIsCalledOpenInMaps() {
        let request = LocationDescription.OpenLocationInMaps.Request()
        sut.openLocationInMaps(request: request)
        
        XCTAssertTrue(worker.isCalledOpenInMaps)
    }
    
    func testCopiedCoordinatesAreEqualToLocationCoordinates() {
        let request = LocationDescription.CopyCoordinatesToClipboard.Request()
        sut.copyCoordinatesToClipboard(request: request)
        let coordinates = "1.1, 2.2"
        
        XCTAssertEqual(coordinates, UIPasteboard.general.string)
    }
    
    func testAppEntersBackgroundWhenOpeningLocationInMaps() {
        let request = LocationDescription.OpenLocationInMaps.Request()
        sut.openLocationInMaps(request: request)
                
        XCTAssertTrue(worker.isAppMovedToBackground)
    }
}
