//
//  LocationsManager.swift
//  Photato
//
//  Created by Alexander Sivko on 6.08.23.
//

import Foundation
import OSLog

final class LocationsManager {
    static let shared = LocationsManager(firebaseManager: FirebaseManager())
    
    private init(firebaseManager: FirebaseLocationsLogic) {
        self.firebaseManager = firebaseManager
    }
    
    private let firebaseManager: FirebaseLocationsLogic
    private let logger = Logger()
    var locations = [Location]()
    
    func downloadLocations(completion: @escaping (FirebaseError?) -> Void) {
        firebaseManager.retrieveLocations { [weak self] result in
            switch result {
            case .success(let downloadedLocations):
                var locationsVar = downloadedLocations
                let dispatchGroup = DispatchGroup()
                
                for (index, value) in downloadedLocations.enumerated() {
                    dispatchGroup.enter()
                    self?.firebaseManager.retrieveFirstImageData(for: value.name) { result in
                        switch result {
                        case .success(let data):
                            locationsVar[index] = locationsVar[index].addNewImagesData(data: [data])
                            dispatchGroup.leave()
                        case .failure(let error):
                            completion(error)
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self?.locations = locationsVar
                    completion(nil)
                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func downloadImagesCount(for locationName: String, completion: @escaping (Int) -> ()) {
        firebaseManager.retrieveImagesCount(for: locationName) { [weak self] result in
            switch result {
            case .success(let imagesCount):
                completion(imagesCount)
            case .failure(let error):
                self?.logger.error("\(error.localizedDescription)")
            }
        }
    }
    
    func downloadAllImages(for locationName: String, completion: @escaping (Result<[Data], FirebaseError>) -> Void) {
        firebaseManager.retrieveAllImages(for: locationName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let imagesData):
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
                
                completion(.success(imagesDataWithCorrectFirstImage))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
