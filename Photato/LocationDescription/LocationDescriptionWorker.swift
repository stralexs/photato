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
    func getFavoriteStatus(for locationName: String) -> Bool
    func setFavoriteStatus(for locationName: String)
}

final class LocationDescriptionWorker: LocationDescriptionWorkingLogic {
    private let firebaseManager: FirebaseUserLogic
    
    func openInMaps(for location: Location) {
        let latitude: CLLocationDegrees = location.coordinates.latitude
        let longitude: CLLocationDegrees = location.coordinates.longitude
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = "\(location.name)"
        mapItem.openInMaps()
    }
    
    func getFavoriteStatus(for locationName: String) -> Bool {
        UserManager.shared.user.favoriteLocations.contains(locationName)
    }
    
    func setFavoriteStatus(for locationName: String) {
        if UserManager.shared.user.favoriteLocations.contains(locationName) {
            firebaseManager.removeLocationFromFavorites(locationName)
            UserManager.shared.user = UserManager.shared.user.removeLocationFromFavorites(locationName: locationName)
        } else {
            firebaseManager.addLocationToFavorites(locationName)
            UserManager.shared.user = UserManager.shared.user.addNewFavoriteLocation(locationName: locationName)
        }
    }
    
    init(firebaseManager: FirebaseUserLogic) {
        self.firebaseManager = firebaseManager
    }
}
