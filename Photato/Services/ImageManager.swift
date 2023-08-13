//
//  ImageManager.swift
//  Photato
//
//  Created by Alexander Strelnikov on 6.08.23.
//

import UIKit

protocol ImageManagerLogic {
    func getImageData(for imageName: String) -> Data
}

class ImageManager: ImageManagerLogic {
    func getImageData(for imageName: String) -> Data {
        guard let imageData = UIImage(named: imageName)?.pngData() else { return Data() }
        return imageData
    }
}
