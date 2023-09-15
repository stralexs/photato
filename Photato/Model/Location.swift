//
//  Location.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import Foundation

struct Location {
    struct Coordinates {
        let latitude: Double
        let longitude: Double
    }
    
    let name: String
    let description: String
    let address: String
    let coordinates: Coordinates
    let imagesData: [Data]
    
    func addNewImagesData(data: [Data]) -> Self {
        .init(name: name,
              description: description,
              address: address,
              coordinates: coordinates,
              imagesData: data)
    }
}

