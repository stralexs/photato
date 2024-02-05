//
//  NetworkConnectionStatusDelegate.swift
//  Photato
//
//  Created by Alexander Sivko on 5.02.24.
//

import UIKit

protocol NetworkConnectionStatusDelegate: AnyObject {
    func internetConnectionStatus(_ isConnectedToInternet: Bool)
}

extension NetworkConnectionStatusDelegate {
    func internetConnectionStatus(_ isConnectedToInternet: Bool) {
        if let self = self as? UIViewController {
            if !isConnectedToInternet {
                self.presentBasicAlert(title: "You're offline", message: "Internet connection is required for correct operation. Please check your connection", actions: [.okAction], completionHandler: nil)
            }
        }
    }
}
