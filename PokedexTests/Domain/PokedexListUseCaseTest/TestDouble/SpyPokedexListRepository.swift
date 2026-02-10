//
//  SpyPokedexListRepository.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import Foundation

final class SpyPokedexListRepository: PokedexListRepositoryProtocol {
    // 에러케이스 설정
    var isOffline: Bool = false
    var isUnknown: Bool = false
    var isAsync: Bool = false
    var pokemonImageRawData: Data?
    private(set) var fetchPokemonIDListCallCount = 0
    
    let pokemonIDList: [PokemonID] = Array(0...21-1)
    let unknownError = NSError(domain: "Unknown", code: -1)
    
    func fetchPokemonIDList() async throws -> [PokemonID] {
        fetchPokemonIDListCallCount += 1
        
        if isAsync {
                try? await Task.sleep(nanoseconds: 1_000_000)
        }
        
        guard !isOffline else { throw PokedexListRepositoryError.offline }
        
        guard !isUnknown else { throw unknownError }
        
        return pokemonIDList
    }
    
    func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData {
        guard !isOffline, !isUnknown else { throw unknownError }
        
        guard let pokemonImageRawData else { throw unknownError }
        
        return PokemonImageData(pokemonID: pokemonID, data: pokemonImageRawData)
    }
    
}


