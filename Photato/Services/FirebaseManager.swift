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

protocol FirebaseUserLogic {
    func fetchUser(_ authResult: AuthDataResult?, completion: @escaping (Result<User, FirebaseError>) -> Void)
    func createUser(_ uid: String, _ name: String, _ email: String, _ profilePicture: Data)
    func addLocationToFavorites(_ locationName: String)
    func removeLocationFromFavorites(_ locationName: String)
}

enum FirebaseError: Error {
    case dataNotLoaded
    case imageDataNotLoaded
    case failedToSignUp
    case occupiedEmail
    case failedToSignIn
    case failedToGetUserData
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
                completion(.failure(.dataNotLoaded))
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
                completion(.failure(.imageDataNotLoaded))
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
                completion(.failure(.dataNotLoaded))
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
                    completion(.failure(.imageDataNotLoaded))
                }
                
                guard let data = data else { completion(.failure(.imageDataNotLoaded)); return }
                completion(.success(data))
            }
        }
    }
    
    func retrieveAllImages(for locationName: String, completion: @escaping (Result<[Data], FirebaseError>) -> Void) {
        db.collection("locations").getDocuments { [weak self] snapshot, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                completion(.failure(.imageDataNotLoaded))
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
                        completion(.failure(.imageDataNotLoaded))
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
                    try? completion(.failedToSignUp)
                }
            })
            
            self?.db.collection("users").document("\(result.user.uid)").setData(["name": name,
                                                                                 "uid": result.user.uid,
                                                                                 "profilePictureUrl": "/usersProfilePictures/\(result.user.uid)/\(imageUUID).jpg",
                                                                                 "favoriteLocations": [String]()
                                                                                ]) { error in
                if let error {
                    self?.logger.error("\(error.localizedDescription)")
                    try? completion(.failedToSignUp)
                }
            }
            
            self?.createUser(result.user.uid, name, email, profilePicture)
            try? completion(nil)
        }
    }
    
    func signInUser(_ email: String, _ password: String, completion: @escaping (FirebaseError?) throws -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                try? completion(.failedToSignIn)
            }
            if error == nil {
                self?.fetchUser(result) { fetchingResult in
                    switch fetchingResult {
                    case .success(let user):
                        UserManager.shared.user = user
                        try? completion(nil)
                    case .failure(let error):
                        try? completion(error)
                    }
                }
            }
        }
    }
}

extension FirebaseManager: FirebaseUserLogic {
    func fetchUser(_ authResult: AuthDataResult?, completion: @escaping (Result<User, FirebaseError>) -> Void) {
        guard let result = authResult,
              let email = result.user.email else { completion(.failure(.failedToGetUserData)); return }
        
        db.collection("users").getDocuments { [weak self] snapshot, error in
            if let error {
                self?.logger.error("\(error.localizedDescription)")
                completion(.failure(.dataNotLoaded))
            }
            
            guard let userDocument = snapshot?.documents.filter({ $0.get("uid") as! String == result.user.uid }).first,
                  let fileRef = self?.storageRef.child("\(userDocument.get("profilePictureUrl") as! String)") else { completion(.failure(.failedToGetUserData)); return }
            
            fileRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
                if let error {
                    self?.logger.error("\(error.localizedDescription)")
                    completion(.failure(.failedToGetUserData))
                }
            
                guard let data = data else { completion(.failure(.failedToGetUserData)); return }
                
                let user = User(uid: result.user.uid,
                                name: userDocument.get("name") as! String,
                                email: email,
                                profilePicture: data,
                                favoriteLocations: userDocument.get("favoriteLocations") as! [String])
                
                completion(.success(user))
            }
        }
    }
    
    func createUser(_ uid: String, _ name: String, _ email: String, _ profilePicture: Data) {
        let user = User(uid: uid,
                        name: name,
                        email: email,
                        profilePicture: profilePicture,
                        favoriteLocations: [])
        UserManager.shared.user = user
    }
    
    func addLocationToFavorites(_ locationName: String) {
        let uid = UserManager.shared.user.uid
        
        db.collection("users").document(uid).updateData([
            "favoriteLocations": FieldValue.arrayUnion(["\(locationName)"])
        ])
    }
    
    func removeLocationFromFavorites(_ locationName: String) {
        let uid = UserManager.shared.user.uid
        
        db.collection("users").document(uid).updateData([
            "favoriteLocations": FieldValue.arrayRemove(["\(locationName)"])
        ])
    }
}
