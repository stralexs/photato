//
//  LocationDescriptionWorker.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import MapKit

protocol LocationDescriptionWorkingLogic {
    func openInMaps(for location: Location)
}

class LocationDescriptionWorker: LocationDescriptionWorkingLogic {
    func openInMaps(for location: Location) {
        let latitude: CLLocationDegrees = location.coordinates.latitude
        let longitude: CLLocationDegrees = location.coordinates.longitude
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = "\(location.name)"
        mapItem.openInMaps()
    }
}
