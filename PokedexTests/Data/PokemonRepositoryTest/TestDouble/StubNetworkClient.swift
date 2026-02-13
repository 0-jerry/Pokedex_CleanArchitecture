//
//  StubNetworkClient.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

import Foundation

final class StubNetworkClient: NetworkClientProtocol {
    let unknownError = NSError(domain: "Unknown", code: -1)
    var callCount: Int = 0
    var isEnable: Bool = true
    var response: [URL: Data] = [:]
    
    func fetch(_ url: URL) async throws -> Data {
        callCount += 1

        guard isEnable else {
            throw unknownError
        }
                
        guard let data = response[url] else {
            throw NSError(domain: "", code: 1)
        }
        
        return data
    }
}
