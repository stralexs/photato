//
//  FirebaseManager.swift
//  Photato
//
//  Created by Alexander Sivko on 4.09.23.
//

import UIKit
import Firebase
import FirebaseStorage
import OSLog

protocol FirebaseManagerLogic {
    func retrieveLocations(completion: @escaping ([Location]) -> Void)
    func retrieveFirstImageData(for locationName: String, completion: @escaping (Data) -> Void)
    func retrieveImagesCount(for locationName: String, completion: @escaping (Int) -> ())
    func retrieveAllImages(for locationName: String, completion: @escaping ([Data]) -> Void)
}

final class FirebaseManager: FirebaseManagerLogic {
    private let db = Firestore.firestore()
    private let logger = Logger()
    
    func retrieveLocations(completion: @escaping ([Location]) -> Void) {
        db.collection("locations").getDocuments { [weak self] snapshot, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                return
            }
            
            guard snapshot != nil,
                  let snapshot = snapshot else { return }
            
            let locations: [Location] = snapshot.documents.map { snapshot in
                let location = Location(name: snapshot.get("name") as! String,
                                        description: snapshot.get("description") as! String,
                                        address: snapshot.get("address") as! String,
                                        coordinates: Location.Coordinates(latitude: snapshot.get("latitude") as! Double, longitude: snapshot.get("longitude") as! Double),
                                        imagesData: [])
                return location
            }
            
            completion(locations)
        }
    }
    
    func retrieveImagesCount(for locationName: String, completion: @escaping (Int) -> Void) {
        db.collection("locations").getDocuments { [weak self] snapshot, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                return
            }
            
            guard snapshot != nil,
                  let snapshot = snapshot else { return }
            
            snapshot.documents.forEach { document in
                let documentName = document.get("name") as! String
                let imagesPaths = document.get("imagesUrls") as! [String]
                
                if documentName == locationName {
                    completion(imagesPaths.count)
                }
            }
        }
    }
    
    func retrieveFirstImageData(for locationName: String, completion: @escaping (Data) -> Void) {
        db.collection("locations").getDocuments { [weak self] snapshot, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                return
            }
            
            guard snapshot != nil,
                  let snapshot = snapshot else { return }
            
            var firstPath: String?
            snapshot.documents.forEach { document in
                let documentName = document.get("name") as! String
                let imagesPaths = document.get("imagesUrls") as! [String]
                
                if documentName == locationName {
                    firstPath = imagesPaths.first
                }
            }
            
            guard let firstPath = firstPath else { return }
            let defaultImage = UIImage(named: "DefaultImage")!.pngData()!
            let storageRef = Storage.storage().reference()
            let fileRef = storageRef.child(firstPath)
            
            fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error {
                    self?.logger.error("\(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { completion(defaultImage); return }
                completion(data)
            }
        }
    }
    
    func retrieveAllImages(for locationName: String, completion: @escaping ([Data]) -> Void) {
        db.collection("locations").getDocuments { [weak self] snapshot, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                return
            }
            
            guard snapshot != nil,
                  let snapshot = snapshot else { return }
            
            var imagesUrls: [String]?
            snapshot.documents.forEach { document in
                let documentName = document.get("name") as! String
                let imagesPaths = document.get("imagesUrls") as! [String]
                
                if documentName == locationName {
                    imagesUrls = imagesPaths
                }
            }
            
            guard let imagesUrls = imagesUrls?.sorted() else { return }
            let defaultImage = UIImage(named: "DefaultImage")!.pngData()!
            let storageRef = Storage.storage().reference()
            var locationImagesData = [Data]()
            
            let dispatchGroup = DispatchGroup()
            
            imagesUrls.forEach { url in
                let fileRef = storageRef.child(url)
                dispatchGroup.enter()
                fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if let error {
                        self?.logger.error("\(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data else { locationImagesData.append(defaultImage); return }
                    locationImagesData.append(data)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                if locationImagesData.count == imagesUrls.count {
                    completion(locationImagesData)
                }
            }
        }
    }
}
