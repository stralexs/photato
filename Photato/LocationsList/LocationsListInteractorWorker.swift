//
//  LocationsListWorker.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

class LocationsListInteractorWorker {
    func fetchLocations() -> [Location] {
        var locations: [Location] = []
        locations = LocationsManager().defaultLocations
        return locations
    }
}
