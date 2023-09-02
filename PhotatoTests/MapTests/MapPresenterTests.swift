//
//  MapPresenterTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 2.09.23.
//

import XCTest
import MapKit
@testable import Photato

final class MapPresenterTests: XCTestCase {
    private var sut: MapPresenter!
    private var viewController: MapDisplayLogicSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let mapPresenter = MapPresenter()
        let mapViewController = MapDisplayLogicSpy()
        
        mapPresenter.viewController = mapViewController
        sut = mapPresenter
        viewController = mapViewController
    }

    override func tearDownWithError() throws {
        sut = nil
        viewController = nil
        try super.tearDownWithError()
    }
    
    func testSutIsNotNil() {
        XCTAssertNotNil(sut)
    }
    
    func testIsCalledDisplayLocationServicesStatus() {
        let isLocationSevicesEnabled = true
        let response = Map.CheckLocationServicesEnabled.Response(isLocationServicesEnabled: isLocationSevicesEnabled)
        sut.presentLocationServicesStatus(response: response)
        
        XCTAssertTrue(viewController.isCalledDisplayLocationServicesStatus)
    }
    
    func testIsCalledDisplayAuthorizationStatus() {
        let locationAuthorizationStatus = true
        let response = Map.CheckAuthorizationStatus.Response(locationAuthorizationStatus: locationAuthorizationStatus)
        sut.presentAuthorizationStatus(response: response)
        
        XCTAssertTrue(viewController.isCalledDisplayAuthorizationStatus)
    }
    
    func testIsCalledDisplayLocations() {
        let location = Location(name: "Foo", description: "Bar", address: "Baz", coordinates: Location.Coordinates(latitude: 0.0, longitude: 0.0), imagesData: [Data()])
        let response = Map.GetLocationsAnnotations.Response(locations: [location])
        sut.presentLocationsAnnotations(response: response)
        
        XCTAssertTrue(viewController.isCalledDisplayLocations)
    }
    
    func testPresenterTransformsLocationToMKPointAnnotation() {
        let location = Location(name: "Foo", description: "Bar", address: "Baz", coordinates: Location.Coordinates(latitude: 0.0, longitude: 0.0), imagesData: [Data()])
        let response = Map.GetLocationsAnnotations.Response(locations: [location])
        let latitude: CLLocationDegrees = location.coordinates.latitude
        let longitude: CLLocationDegrees = location.coordinates.longitude
        sut.presentLocationsAnnotations(response: response)
        
        XCTAssertEqual(location.name, viewController.mapView.annotations.first?.title)
        XCTAssertEqual(location.address, viewController.mapView.annotations.first?.subtitle)
        XCTAssertEqual(latitude, viewController.mapView.annotations.first?.coordinate.latitude)
        XCTAssertEqual(longitude, viewController.mapView.annotations.first?.coordinate.longitude)
    }
}
