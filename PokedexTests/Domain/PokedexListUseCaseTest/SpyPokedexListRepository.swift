//
//  SpyPokedexListRepository.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

final class SpyPokedexListRepository: PokedexListRepositoryProtocol {
    // 에러케이스 설정
    var isOffline: Bool = false
    var isUnknown: Bool = false
    
    var isLoadingPokemonIDList: Bool = false
    var pokemonImageRawData: Data?
    private(set) var loadingCount = 0
    
    let pokemonIDList: [PokemonID] = Array(0...21-1)
    let unknownError = NSError(domain: "Unknown", code: -1)
    
    func fetchPokemonIDList() async throws -> [PokemonID] {
        isLoadingPokemonIDList = true
        loadingCount += 1
        // API 로딩중인 경우 리턴 방지
        while isLoadingPokemonIDList {}
        
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


