//
//  PhotatoTests.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 5.08.23.
//

import XCTest
@testable import Photato

final class LocationTests: XCTestCase {
    var location: Location?
    var image: UIImage?
    var imageData: Data?
    var coordinates: Location.Coordinates?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        image = UIImage(named: "BotanicalGarden1")
        guard let image = image else { return }
        imageData = image.pngData()
        coordinates = Location.Coordinates(longitude: 0.0, latitude: 0.0)
        guard let imageData = imageData,
              let coordinates = coordinates else { return }
        location = Location(name: "Foo",
                            description: "Bar",
                            address: "Baz",
                            coordinates: coordinates,
                            imagesData: [imageData]
        )
    }

    override func tearDownWithError() throws {
        location = nil
        image = nil
        imageData = nil
        coordinates = nil
        try super.tearDownWithError()
    }
    
    func testLocationInit() {
        XCTAssertNotNil(location)
    }
    
    func testWhenGivenLocationSetsItsParamaters() {
        guard let location = location else { return }
        XCTAssertEqual(location.name, "Foo")
        XCTAssertEqual(location.description, "Bar")
        XCTAssertEqual(location.address, "Baz")
        XCTAssertEqual(location.coordinates, coordinates)
        XCTAssertEqual(location.imagesData, [imageData])
    }
}
