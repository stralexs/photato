//
//  LocationDescriptionBusinessLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Strelnikov on 13.08.23.
//

import UIKit
@testable import Photato

final class LocationDescriptionBusinessLogicSpy: LocationDescriptionBusinessLogic {
    private(set) var isCalledShowLocationDescription = false
    private(set) var isCalledCopyCoordinatesToClipboard = false
    private(set) var isCalledOpenLocationInMaps = false
    
    func showLocationDescription(request: LocationDescription.ShowLocationDescription.Request) {
        isCalledShowLocationDescription = true
    }
    
    func copyCoordinatesToClipboard(request: LocationDescription.CopyCoordinatesToClipboard.Request) {
        isCalledCopyCoordinatesToClipboard = true
    }
    
    func openLocationInMaps(request: LocationDescription.OpenLocationInMaps.Request) {
        isCalledOpenLocationInMaps = true
    }
}

