//
//  LocationsListWorker.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit
import OSLog

protocol LocationsListWorkingLogic {
    func fetchLocations(completion: @escaping (Result<[Location], FirebaseError>) -> Void)
    func searchLocations(using searchText: String, completion: @escaping ([Location]) -> Void)
}

final class LocationsListWorker: LocationsListWorkingLogic {
    private let logger = Logger()
    
    func fetchLocations(completion: @escaping (Result<[Location], FirebaseError>) -> Void) {
        LocationsManager.shared.provideLocations { result in
            switch result {
            case .success(let locations):
                completion(.success(locations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchLocations(using searchText: String, completion: @escaping ([Location]) -> Void) {
        LocationsManager.shared.provideLocations { [weak self] result in
            switch result {
            case .success(let locations):
                let filteredLocations: [Location]
                if searchText == "" {
                    filteredLocations = locations
                } else {
                    filteredLocations = locations.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                }
                completion(filteredLocations)
            case .failure(let error):
                self?.logger.error("\(error.localizedDescription)")
            }
        }
    }
}
