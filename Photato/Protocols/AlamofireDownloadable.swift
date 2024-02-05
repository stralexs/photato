//
//  AlamofireDownloadable.swift
//  Photato
//
//  Created by Alexander Sivko on 28.12.23.
//

import Foundation
import Alamofire

protocol AlamofireDownloadable {
    associatedtype DecodableModel: Decodable
    func getData(_ urlString: String) async throws -> DecodableModel
}

extension AlamofireDownloadable {
    func getData(_ urlString: String) async throws -> DecodableModel {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dataDecoder: DataDecoder = jsonDecoder
        let decodedData = try await AF.request(urlString)
            .validate()
            .serializingDecodable(DecodableModel.self, decoder: dataDecoder)
            .value
        return decodedData
    }
}
