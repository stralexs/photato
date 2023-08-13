//
//  LocationDescriptionViewControllerTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 13.08.23.
//

import XCTest
@testable import Photato

final class LocationDescriptionViewControllerTests: XCTestCase {
    private var sut: LocationDescriptionViewController!
    private var interactor: LocationDescriptionBusinessLogicSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let locationDescriptiontViewController = storyboard.instantiateViewController(identifier: "LocationDescriptionViewController") as? LocationDescriptionViewController
        let locationDescriptionInteractor = LocationDescriptionBusinessLogicSpy()
            
        locationDescriptiontViewController?.interactor = locationDescriptionInteractor
        interactor = locationDescriptionInteractor
        sut = locationDescriptiontViewController
        
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
    
    func testIsCalledShowLocationDesription() {
        let request = LocationDescription.ShowLocationDescription.Request()
        interactor.showLocationDescription(request: request)
        XCTAssertTrue(interactor.isCalledShowLocationDescription)
    }
    
    func testIsCalledCopyCoordinatesToClipboard() {
        let request = LocationDescription.CopyCoordinatesToClipboard.Request()
        interactor.copyCoordinatesToClipboard(request: request)
        XCTAssertTrue(interactor.isCalledCopyCoordinatesToClipboard)
    }
    
    func testIsCalledOpenLocationInMaps() {
        let request = LocationDescription.OpenLocationInMaps.Request()
        interactor.openLocationInMaps(request: request)
        XCTAssertTrue(interactor.isCalledOpenLocationInMaps)
    }
    
    func testLocationIsDisplayed() {
        guard let imageData = UIImage(named: "OktyabrskayaStreet1")?.pngData() else { return }
        let displayedLocation = LocationDescription.ShowLocationDescription.ViewModel.DisplayedLocation(name: "Foo", description: "Bar", address: "Baz", coordinates: "0.0, 0.0", imagesData: [imageData])
        let viewModel = LocationDescription.ShowLocationDescription.ViewModel(displayedLocation: displayedLocation)
        sut.displayLocationDescription(viewModel: viewModel)
        
        XCTAssertNotNil(sut.locationImageView.image)
        XCTAssertNotNil(sut.locationNameLabel.text)
        XCTAssertNotNil(sut.locationAddressLabel.text)
        XCTAssertNotNil(sut.locationDescriptionTextView.text)
        XCTAssertNotNil(sut.locationCoordinatesLabel.text)
    }
}
