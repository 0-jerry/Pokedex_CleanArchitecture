//
//  URLSessionNetworkClient.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import Foundation

struct URLSessionNetworkClient: NetworkClientProtocol {
    
    func fetch(_ url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
}
