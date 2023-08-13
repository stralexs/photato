//
//  Location.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import Foundation

struct Location {
    struct Coordinates {
        var latitude: Double
        var longitude: Double
    }
    
    var name: String
    var description: String
    var address: String
    var coordinates: Coordinates
    var imagesData: [Data]
}

