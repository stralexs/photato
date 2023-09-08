//
//  FirebaseManager.swift
//  Photato
//
//  Created by Alexander Sivko on 4.09.23.
//

import UIKit
import Firebase
import FirebaseStorage

protocol FirebaseManagerLogic {
    func retrieveLocations(completion: @escaping ([Location]) -> Void)
    func retrieveFirstImageData(for locationName: String, completion: @escaping (Data) -> Void)
    func retrieveImagesCount(for locationName: String, completion: @escaping (Int) -> ())
    func retrieveAllImages(for locationName: String, completion: @escaping ([Data]) -> Void)
}

class FirebaseManager: FirebaseManagerLogic {
    func retrieveLocations(completion: @escaping ([Location]) -> Void) {
        var locations: [Location] = []
        let db = Firestore.firestore()
        
        db.collection("locations").getDocuments { snapshot, error in
            guard error == nil,
                  snapshot != nil,
                  let snapshot = snapshot else { return }
            
            snapshot.documents.forEach { document in
                var location = Location(name: document.get("name") as! String,
                                        description: document.get("description") as! String,
                                        address: document.get("address") as! String,
                                        coordinates: Location.Coordinates(latitude: document.get("latitude") as! Double, longitude: document.get("longitude") as! Double),
                                        imagesData: [])
                
                locations.append(location)
                
                self.retrieveFirstImageData(for: location.name) { data in
                    location.imagesData.append(data)
                }
            }
        
            completion(locations)
        }
    }
    
    func retrieveImagesCount(for locationName: String, completion: @escaping (Int) -> ()) {
        let db = Firestore.firestore()
        
        db.collection("locations").getDocuments { snapshot, error in
            guard error == nil,
                  snapshot != nil,
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
        let db = Firestore.firestore()
        
        db.collection("locations").getDocuments { snapshot, error in
            guard error == nil,
                  snapshot != nil,
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
                guard error == nil, let data = data else { completion(defaultImage); return }
                completion(data)
            }
        }
    }
    
    func retrieveAllImages(for locationName: String, completion: @escaping ([Data]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("locations").getDocuments { snapshot, error in
            guard error == nil,
                  snapshot != nil,
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
            var locationImagesData: [Data] = []
            
            let dispatchGroup = DispatchGroup()
            
            imagesUrls.forEach { url in
                let fileRef = storageRef.child(url)
                dispatchGroup.enter()
                fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    guard error == nil, let data = data else { locationImagesData.append(defaultImage); return }
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
