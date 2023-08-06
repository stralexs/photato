//
//  LocationsListPresenterWorker.swift
//  Photato
//
//  Created by Alexander Sivko on 6.08.23.
//

import Foundation

class LocationsListPresenterWorker {
    func getDisplayedLocations(from locations: [Location]) -> [LocationsList.FetchLocations.ViewModel.DisplayedLocation] {
        var displayedLocations: [LocationsList.FetchLocations.ViewModel.DisplayedLocation] = []
        
        locations.forEach { location in
            let name = location.name
            let address = location.address
            let imagesData = location.imagesData
            
            let displayedLocation = LocationsList.FetchLocations.ViewModel.DisplayedLocation(
                name: name,
                address: address,
                imageData: imagesData.first ?? Data()
            )
            displayedLocations.append(displayedLocation)
        }
        
        return displayedLocations
    }
}
