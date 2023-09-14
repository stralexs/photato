//
//  LocationsManager.swift
//  Photato
//
//  Created by Alexander Sivko on 6.08.23.
//

import Foundation

class LocationsManager {
    static let shared = LocationsManager(firebaseManager: FirebaseManager())
    
    private init(firebaseManager: FirebaseManagerLogic) {
        self.firebaseManager = firebaseManager
    }
    
    func downloadLocations(completion: @escaping ([Location]) -> Void) {
        firebaseManager.retrieveLocations { [weak self] locations in
            var locationsVar = locations
            let dispatchGroup = DispatchGroup()
                   
            for (index, value) in locations.enumerated() {
                dispatchGroup.enter()
                self?.firebaseManager.retrieveFirstImageData(for: value.name) { data in
                    locationsVar[index].imagesData.append(data)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self?.locations = locationsVar
                completion(locationsVar)
            }
        }
    }
    
    func downloadImagesCount(for locationName: String, completion: @escaping (Int) -> ()) {
        firebaseManager.retrieveImagesCount(for: locationName) { imagesCount in
            completion(imagesCount)
        }
    }
    
    func downloadAllImages(for locationName: String, completion: @escaping ([Data]) -> ()) {
        firebaseManager.retrieveAllImages(for: locationName) { [weak self] imagesData in
            guard let self = self else { return }
            var locationsVar = self.locations
            let dispatchGroup = DispatchGroup()
            
            for (index, value) in self.locations.enumerated() {
                dispatchGroup.enter()
                if value.name == locationName {
                    locationsVar[index].imagesData = imagesData
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                self.locations = locationsVar
                completion(imagesData)
            }
        }
    }
    
    var firebaseManager: FirebaseManagerLogic
    var locations: [Location] = []
}
