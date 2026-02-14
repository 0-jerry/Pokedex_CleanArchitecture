//
//  NetworkStatusProvider.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import Network

final class NetworkStatusProvider: NetworkStatusProviderProtocol {
    var isConnected: Bool {
        monitor.currentPath.status == .satisfied
    }

    private let monitor: NWPathMonitor = {
        let monitor = NWPathMonitor()
        monitor.start(queue: .main)
        
        return monitor
    }()

    deinit { monitor.cancel() }
    
}

