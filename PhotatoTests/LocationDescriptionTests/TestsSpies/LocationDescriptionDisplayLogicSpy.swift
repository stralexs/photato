//
//  LocationDescriptionDisplayLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 13.08.23.
//

import UIKit
@testable import Photato

final class LocationDescriptionDisplayLogicSpy: LocationDescriptionDisplayLogic {
    private(set) var isCalledDisplayLocationDescription = false
    private(set) var isCalledDisplayCopiedToClipboardMessage = false
    private(set) var locationCoordinatesLabel = UILabel()
    
    func displayLocationDescription(viewModel: LocationDescription.ShowLocationDescription.ViewModel) {
        isCalledDisplayLocationDescription = true
        locationCoordinatesLabel.text = viewModel.displayedLocation.coordinates
    }
    
    func displayCopiedToClipboardMessage(viewModel: LocationDescription.CopyCoordinatesToClipboard.ViewModel) {
        isCalledDisplayCopiedToClipboardMessage = true
    }
}
