//
//  MapPresentationLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 2.09.23.
//

import Foundation
@testable import Photato

final class MapPresentationLogicSpy: MapPresentationLogic {
    private(set) var isCalledPresentLocationServicesStatus = false
    private(set) var isCalledPresentAuthorizationStatus = false
    private(set) var isCalledPresentLocationsAnnotations = false
    
    
    func presentLocationServicesStatus(response: Photato.Map.CheckLocationServicesEnabled.Response) {
        isCalledPresentLocationServicesStatus = true
    }
    
    func presentAuthorizationStatus(response: Photato.Map.CheckAuthorizationStatus.Response) {
        isCalledPresentAuthorizationStatus = true
    }
    
    func presentLocationsAnnotations(response: Photato.Map.GetLocationsAnnotations.Response) {
        isCalledPresentLocationsAnnotations = true
    }
    
}

