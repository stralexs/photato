//
//  LocationsManager.swift
//  Photato
//
//  Created by Alexander Sivko on 6.08.23.
//

import Foundation
import OSLog

final class LocationsManager {
    // MARK: - Singleton
    static let shared = LocationsManager(firebaseManager: FirebaseManager())
    
    private init(firebaseManager: FirebaseLocationsLogic) {
        self.firebaseManager = firebaseManager
    }
    
    // MARK: - Properties
    private let firebaseManager: FirebaseLocationsLogic
    private let logger = Logger()
    private let cache = NSCache<NSString, StructNSCacheWrapper<Location>>()
    private var locationsNames = [NSString]()
    
    // MARK: - Methods
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
                    self?.locationsNames = locationsVar.map { $0.name as NSString }
                    locationsVar.forEach { self?.cache.setObject(StructNSCacheWrapper($0), forKey: $0.name as NSString) }
                    completion(nil)
                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func provideLocations(completion: @escaping (Result<[Location], FirebaseError>) -> Void) {
        var outputLocations = [Location]()
        let dispatchGroup = DispatchGroup()
        
        for locationName in locationsNames {
            dispatchGroup.enter()
            if let cachedLocation = cache.object(forKey: locationName)?.value {
                outputLocations.append(cachedLocation)
                dispatchGroup.leave()
            } else {
                firebaseManager.retrieveLocation(locationName as String) { [weak self] result in
                    switch result {
                    case .success(let location):
                        self?.firebaseManager.retrieveFirstImageData(for: location.name) { result in
                            switch result {
                            case .success(let imageData):
                                let locationWithImageData = location.addNewImagesData(data: [imageData])
                                outputLocations.append(locationWithImageData)
                                dispatchGroup.leave()
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(outputLocations))
        }
    }
    
    func downloadImagesCount(for locationName: String, completion: @escaping (Int) -> Void) {
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
        if let cachedLocation = cache.object(forKey: locationName as NSString)?.value {
            
            if cachedLocation.imagesData.count == 1 {
                firebaseManager.retrieveAllImages(for: locationName) { [weak self] result in
                    
                    switch result {
                    case .success(let imagesData):
                        guard let firstImage = cachedLocation.imagesData.first else { return }
                        var imagesDataWithCorrectFirstImage = imagesData.filter { $0 != firstImage }
                        imagesDataWithCorrectFirstImage.insert(firstImage, at: 0)
                        let locationWithImages = cachedLocation.addNewImagesData(data: imagesDataWithCorrectFirstImage)
                        self?.cache.setObject(StructNSCacheWrapper(locationWithImages), forKey: locationWithImages.name as NSString)
                        completion(.success(imagesDataWithCorrectFirstImage))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            } else {
                completion(.success(cachedLocation.imagesData))
            }
            
        } else {
            firebaseManager.retrieveLocation(locationName) { [weak self] result in
                
                switch result {
                case .success(let location):
                    self?.firebaseManager.retrieveFirstImageData(for: locationName, completion: { result in
                        
                        switch result {
                        case .success(let firstImageData):
                            
                            self?.firebaseManager.retrieveAllImages(for: locationName, completion: { result in
                                
                                switch result {
                                case .success(let imagesData):
                                    var imagesDataWithCorrectFirstImage = imagesData.filter { $0 != firstImageData }
                                    imagesDataWithCorrectFirstImage.insert(firstImageData, at: 0)
                                    let locationWithImages = location.addNewImagesData(data: imagesDataWithCorrectFirstImage)
                                    self?.cache.setObject(StructNSCacheWrapper(locationWithImages), forKey: locationWithImages.name as NSString)
                                    completion(.success(imagesDataWithCorrectFirstImage))
                                    
                                case .failure(let error):
                                    completion(.failure(error))
                                }
                            })
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    })
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
