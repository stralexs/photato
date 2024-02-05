//
//  NetworkConnectionMonitor.swift
//  Photato
//
//  Created by Alexander Sivko on 30.01.24.
//

import Network

final class NetworkConnectionMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    
    private var isConnectedToInternet = true {
        didSet {
            if isConnectedToInternet != oldValue {
                DispatchQueue.main.async {
                    self.delegate?.internetConnectionStatus(self.isConnectedToInternet)
                }
            }
        }
    }
    
    private func internetConnectionMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnectedToInternet = path.status == .satisfied
        }
    }
    
    weak var delegate: NetworkConnectionStatusDelegate? {
        didSet {
            internetConnectionMonitoring()
        }
    }
}
