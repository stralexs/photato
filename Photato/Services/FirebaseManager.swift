//
//  FirebaseManager.swift
//  Photato
//
//  Created by Alexander Sivko on 4.09.23.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import OSLog

protocol FirebaseLocationsLogic {
    func retrieveLocations(completion: @escaping (Result<[Location], FirebaseError>) -> Void)
    func retrieveFirstImageData(for locationName: String, completion: @escaping (Result<Data, FirebaseError>) -> Void)
    func retrieveImagesCount(for locationName: String, completion: @escaping (Result<Int, FirebaseError>) -> Void)
    func retrieveAllImages(for locationName: String, completion: @escaping (Result<[Data], FirebaseError>) -> Void)
}

protocol FirebaseAuthenticationLogic {
    func signUpUser(_ name: String, _ email: String, _ password: String, _ profilePicture: Data, completion: @escaping (FirebaseError?) throws -> Void)
    func signInUser(_ email: String, _ password: String, completion: @escaping (FirebaseError?) throws -> Void)
}

enum FirebaseError: Error {
    case locationsNotLoadedError
    case downloadImageDataError
    case signUpError
    case occupiedEmail
    case signInError
    case unknown
}

final class FirebaseManager: FirebaseLocationsLogic {
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    private let logger = Logger()
    
    func retrieveLocations(completion: @escaping (Result<[Location], FirebaseError>) -> Void) {
        db.collection("locations").getDocuments { [weak self] snapshot, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                completion(.failure(.locationsNotLoadedError))
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
            
            completion(.success(locations))
        }
    }
    
    func retrieveImagesCount(for locationName: String, completion: @escaping (Result<Int, FirebaseError>) -> Void) {
        db.collection("locations").getDocuments { [weak self] snapshot, error in
            if let error {
                completion(.failure(.downloadImageDataError))
                self?.logger.error("\(error.localizedDescription)")
                return
            }
            
            guard snapshot != nil,
                  let snapshot = snapshot else { return }
            
            snapshot.documents.forEach { document in
                let documentName = document.get("name") as! String
                let imagesPaths = document.get("imagesUrls") as! [String]
                
                if documentName == locationName {
                    completion(.success(imagesPaths.count))
                }
            }
        }
    }
    
    func retrieveFirstImageData(for locationName: String, completion: @escaping (Result<Data, FirebaseError>) -> Void) {
        db.collection("locations").getDocuments { [weak self] snapshot, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                completion(.failure(.locationsNotLoadedError))
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
            
            guard let firstPath = firstPath,
                  let fileRef = self?.storageRef.child("/locationsImages\(firstPath)") else { return }
            
            fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error {
                    self?.logger.error("\(error.localizedDescription)")
                    completion(.failure(.downloadImageDataError))
                }
                
                guard let data = data else { completion(.failure(.downloadImageDataError)); return }
                completion(.success(data))
            }
        }
    }
    
    func retrieveAllImages(for locationName: String, completion: @escaping (Result<[Data], FirebaseError>) -> Void) {
        db.collection("locations").getDocuments { [weak self] snapshot, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                completion(.failure(.downloadImageDataError))
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
            var locationImagesData = [Data]()
            
            let dispatchGroup = DispatchGroup()
            
            imagesUrls.forEach { url in
                guard let fileRef = self?.storageRef.child("/locationsImages\(url)") else { return }
                dispatchGroup.enter()
                fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if let error {
                        self?.logger.error("\(error.localizedDescription)")
                        completion(.failure(.downloadImageDataError))
                    }
                    
                    guard let data = data else { locationImagesData.append(defaultImage); return }
                    locationImagesData.append(data)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                if locationImagesData.count == imagesUrls.count {
                    completion(.success(locationImagesData))
                }
            }
        }
    }
}

extension FirebaseManager: FirebaseAuthenticationLogic {
    private var auth: Auth {
        return Auth.auth()
    }
    
    func signUpUser(_ name: String, _ email: String, _ password: String, _ profilePicture: Data, completion: @escaping (FirebaseError?) throws -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                try? completion(.occupiedEmail)
            }
            guard let result = result else { return }
            
            let imageUUID = UUID().uuidString
            let fileRef = self?.storageRef.child("/usersProfilePictures/\(result.user.uid)/\(imageUUID).jpg")
            fileRef?.putData(profilePicture, completion: { metadata, error in
                if let error {
                    self?.logger.error("\(error.localizedDescription)")
                    try? completion(.signUpError)
                }
            })
            
            self?.db.collection("users").addDocument(data: ["name": name,
                                                            "uid": result.user.uid,
                                                            "profilePictureUrl": "/usersProfilePictures/\(result.user.uid)/\(imageUUID).jpg",
                                                            "favoriteLocations": [String]()
                                                           ]) { error in
                if let error {
                    self?.logger.error("\(error.localizedDescription)")
                    try? completion(.signUpError)
                }
            }
            
            try? completion(nil)
        }
    }
    
    func signInUser(_ email: String, _ password: String, completion: @escaping (FirebaseError?) throws -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                try? completion(.signInError)
            }
            if error == nil {
                try? completion(nil)
            }
        }
    }
}
