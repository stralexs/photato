//
//  MapInteractorTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 2.09.23.
//

import XCTest
@testable import Photato

final class MapInteractorTests: XCTestCase {
    private var sut: MapInteractor!
    private var presenter: MapPresentationLogicSpy!
    private var worker: MapWorkingLogicSpy!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let mapWorker = MapWorkingLogicSpy()
        let mapInteractor = MapInteractor(worker: mapWorker)
        let mapPresenter = MapPresentationLogicSpy()
        
        mapInteractor.presenter = mapPresenter
        
        sut = mapInteractor
        presenter = mapPresenter
        worker = mapWorker
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
    
    func testIsCalledCheckLocationServicesStatus() {
        let request = Map.CheckLocationServicesEnabled.Request()
        sut.checkLocationServicesEnabled(request: request)
                
        XCTAssertTrue(presenter.isCalledPresentLocationServicesStatus)
        XCTAssertTrue(worker.isCalledCheckLocationServicesStatus)
    }
    
    func testIsCalledSetupLocationManager() {
        let request = Map.SetupLocationManager.Request()
        sut.setupLocationManager(request: request)
        
        XCTAssertTrue(worker.isCalledSetupLocationManager)
    }
    
    func testIsCalledCheckAuthorizationStatus() {
        let request = Map.CheckAuthorizationStatus.Request()
        sut.checkAuthorizationStatus(request: request)
        
        XCTAssertTrue(worker.isCalledCheckAuthorizationStatus)
        XCTAssertTrue(presenter.isCalledPresentAuthorizationStatus)
    }
    
    func testIsCalledFetchLocations() {
        let request = Map.GetLocationsAnnotations.Request()
        sut.fetchLocations(request: request)
        
        XCTAssertTrue(worker.isCalledFetchLocations)
        XCTAssertTrue(presenter.isCalledPresentLocationsAnnotations)
    }
}
