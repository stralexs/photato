//
//  MapViewControllerTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 2.09.23.
//

import XCTest
import MapKit
@testable import Photato

final class MapViewControllerTests: XCTestCase {
    private var sut: MapViewController!
    private var interactor: MapBusinessLogicSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewController(identifier: "MapViewController") as? MapViewController
        let mapInteractor = MapBusinessLogicSpy()
        
        mapViewController?.interactor = mapInteractor
        sut = mapViewController
        interactor = mapInteractor
        
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
    
    func testIsCalledCheckLocationServicesEnabled() {
        let request = Map.CheckLocationServicesEnabled.Request()
        interactor.checkLocationServicesEnabled(request: request)
        
        XCTAssertTrue(interactor.isCalledCheckLocationServicesEnabled)
    }
    
    func testIsCalledSetupLocationManager() {
        let request = Map.SetupLocationManager.Request()
        interactor.setupLocationManager(request: request)
        
        XCTAssertTrue(interactor.isCalledSetupLocationManager)
    }
    
    func testIsCalledCheckAuthorizationStatus() {
        let request = Map.CheckAuthorizationStatus.Request()
        interactor.checkAuthorizationStatus(request: request)
        
        XCTAssertTrue(interactor.isCalledCheckAuthorizationStatus)
    }
    
    func testIsCalledFetchLocations() {
        let request = Map.GetLocationsAnnotations.Request()
        interactor.fetchLocations(request: request)
        
        XCTAssertTrue(interactor.isCalledFetchLocations)
    }
    
    func testMapViewContainsAnnotations() {
        let annotationFirst = MKPointAnnotation()
        let annotationSecond = MKPointAnnotation()
        let annotations: [MKAnnotation] = [annotationFirst, annotationSecond]
        let viewModel = Map.GetLocationsAnnotations.ViewModel(annotations: annotations)
        sut.displayLocations(viewModel: viewModel)
        
        XCTAssertTrue(!sut.mapView.annotations.isEmpty)
        XCTAssertEqual(sut.mapView.annotations.count, 2)
    }
    
    func testMapViewShowsUserLocationIfAuthorized() {
        let authorizationStatus = true
        let viewModel = Map.CheckAuthorizationStatus.ViewModel(locationAuthorizationStatus: authorizationStatus)
        sut.displayAuthorizationStatus(viewModel: viewModel)
        
        XCTAssertTrue(sut.mapView.showsUserLocation)
    }
}
