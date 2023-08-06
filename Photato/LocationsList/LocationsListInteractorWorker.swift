//
//  LocationsListWorker.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

class LocationsListInteractorWorker {
    func fetchLocations(using searchText: String) -> [Location] {
        let locations: [Location] = LocationsManager().defaultLocations
        var filteredLocations: [Location] = []
        
        if searchText == "" {
            filteredLocations = locations
        } else {
            locations.forEach { location in
                if location.name.lowercased().contains(searchText.lowercased()) {
                    filteredLocations.append(location)
                }
            }
        }
        
        return filteredLocations
    }
}
