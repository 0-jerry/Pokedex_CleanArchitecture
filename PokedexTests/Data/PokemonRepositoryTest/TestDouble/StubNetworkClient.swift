//
//  StubNetworkClient.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

import Foundation

final class StubNetworkClient: NetworkClientProtocol {
    var unknownError: (any Error)!
    var callCount: Int = 0
    var isEnable: Bool = true
    var namedAPIResourceListDTO: [URL: NamedAPIResourceList] = [:]
    var pokemonDTO: [URL: PokemonDTO] = [:]
    var pokemonImageDTO: [URL: Data] = [:]

    func fetch<DTO: Decodable>(_ url: URL) async throws -> DTO {
        guard isEnable else { throw unknownError }
        
        callCount += 1
        
        if DTO.self is NamedAPIResourceList.Type {
            guard let result = self.namedAPIResourceListDTO[url] as? DTO else { throw unknownError }
            return result
            
        } else if DTO.self is PokemonDTO.Type {
            guard let result = self.pokemonDTO[url] as? DTO else { throw unknownError }
            return result
            
        } else if DTO.self is Data.Type {
            guard let result = self.pokemonImageDTO[url] as? DTO else { throw unknownError }
            return result
        } else {
            throw unknownError
        }
    }
}
