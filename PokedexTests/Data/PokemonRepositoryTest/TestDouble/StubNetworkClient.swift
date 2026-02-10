//
//  StubNetworkClient.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

import Foundation

final class StubNetworkClient: NetworkClientProtocol {
    let error = URLError(.unknown)
    var callCount: Int = 0
    var isEnable: Bool = true
    var namedAPIResourceListDTO: [URL: NamedAPIResourceList] = [:]
    var pokemonDTO: [URL: PokemonDTO] = [:]
    var pokemonImageDTO: [URL: Data] = [:]

    func fetch<DTO>(_ url: URL) async throws -> DTO where DTO : Decodable {
        guard isEnable else { throw error }
        
        if DTO.self is NamedAPIResourceList.Type {
            guard let result = self.namedAPIResourceListDTO[url] as? DTO else {
                throw error
            }
            return result
            
        } else if DTO.self is PokemonDTO.Type {
            guard let result = self.pokemonDTO[url] as? DTO else {
                throw error
            }
            return result
            
        } else if DTO.self is Data.Type {
            guard let result = self.pokemonImageDTO[url] as? DTO else {
                throw error
            }
            return result
        }
    }
}
