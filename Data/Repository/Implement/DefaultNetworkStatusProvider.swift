//
//  NetworkStatusProvider.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import Network

final class NetworkStatusProvider: NetworkStatusProviderProtocol {
    
    private let monitor: NWPathMonitor = .init()
    private(set) var isConnected: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: .main)
    }

    deinit { monitor.cancel() }
    
}

