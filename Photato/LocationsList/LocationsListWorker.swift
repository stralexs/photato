//
//  LocationsListWorker.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

protocol LocationsListWorkingLogic {
    func fetchLocations() -> [Location]
    func searchLocations(using searchText: String) -> [Location]
}

class LocationsListWorker: LocationsListWorkingLogic {
    func fetchLocations() -> [Location] {
        return LocationsManager().defaultLocations
    }
    
    func searchLocations(using searchText: String) -> [Location] {
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
