//
//  LocationDescriptionWorkingLogicSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 13.08.23.
//

import MapKit
@testable import Photato

final class LocationDescriptionWorkingLogicSpy: LocationDescriptionWorkingLogic {
    private(set) var isCalledOpenInMaps = false
    private(set) var isAppMovedToBackground = false
    
    func openInMaps(for location: Location) {
        isCalledOpenInMaps = true
        
        let latitude: CLLocationDegrees = location.coordinates.latitude
        let longitude: CLLocationDegrees = location.coordinates.longitude
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = "\(location.name)"
        mapItem.openInMaps()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setAppStatus), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func setAppStatus() {
        isAppMovedToBackground = true
    }
}
