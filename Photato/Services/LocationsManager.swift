//
//  LocationsManager.swift
//  Photato
//
//  Created by Alexander Sivko on 6.08.23.
//

import Foundation

final class LocationsManager {
    static let shared = LocationsManager(firebaseManager: FirebaseManager())
    
    private init(firebaseManager: FirebaseLocationsLogic) {
        self.firebaseManager = firebaseManager
    }
    
    private let firebaseManager: FirebaseLocationsLogic
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
            var imagesDataWithCorrectFirstImage = imagesData
            
            locations = locations.map { location in
                var locationWithImages = location
                
                if location.name == locationName {
                    guard let firstImage = location.imagesData.first else { return location }
                    
                    imagesDataWithCorrectFirstImage = imagesData.filter { $0 != firstImage }
                    imagesDataWithCorrectFirstImage.insert(firstImage, at: 0)
                    locationWithImages = location.addNewImagesData(data: imagesDataWithCorrectFirstImage)
                }
                
                return locationWithImages
            }
            
            completion(imagesDataWithCorrectFirstImage)
        }
    }
}
