//
//  LocationDescriptionPresentationLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 13.08.23.
//

import Foundation
@testable import Photato

final class LocationDescriptionPresentationLogicSpy: LocationDescriptionPresentationLogic {
    private(set) var isCalledPresentLocationDescription = false
    private(set) var isCalledPresentCopiedToClipboardMessage = false
    
    func presentLocationDescription(response: LocationDescription.ShowLocationDescription.Response) {
        isCalledPresentLocationDescription = true
    }
    
    func presentCopiedToClipboardMessage(response: LocationDescription.CopyCoordinatesToClipboard.Response) {
        isCalledPresentCopiedToClipboardMessage = true
    }
}
