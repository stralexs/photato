//
//  LocationsManager.swift
//  Photato
//
//  Created by Alexander Sivko on 6.08.23.
//

import Foundation

final class LocationsManager {
    static let shared = LocationsManager(firebaseManager: FirebaseManager())
    
    private init(firebaseManager: FirebaseManagerLogic) {
        self.firebaseManager = firebaseManager
    }
    
    private let firebaseManager: FirebaseManagerLogic
    var locations = [Location]()
    
    func downloadLocations(completion: @escaping ([Location]) -> Void) {
        firebaseManager.retrieveLocations { [weak self] locations in
            var locationsVar = locations
            let dispatchGroup = DispatchGroup()
            
            for (index, value) in locations.enumerated() {
                dispatchGroup.enter()
                self?.firebaseManager.retrieveFirstImageData(for: value.name) { data in
                    locationsVar[index] = locationsVar[index].addNewImagesData(data: [data])
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
            let locationWithImages: [Location] = self.locations.filter { $0.name == locationName }
                                                               .map { $0.addNewImagesData(data: imagesData) }
            
            self.locations = locationWithImages
            completion(imagesData)
        }
    }
}
