//
//  PokedexListUsecase.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

internal protocol PokedexListUsecaseProtocol: AnyObject {
    func request(_ request: PokedexListRequest)
}

internal protocol PokedexListOutputPort: AnyObject {
    func present(_ response: PokedexListResponse)
}

internal protocol PokedexListRepositoryProtocol {
    func fetchPokemonID(_ offset: Int) async throws -> [PokemonID]
    func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData
}

internal enum PokedexListRepositoryError: Error {
    case offline
    case unknown
}

internal enum PokedexListUsecaseError: Error {
    case offline
    case pokemonImageLoadFaild(PokemonID)
    case unknown
}

internal final class PokedexListUsecase: PokedexListUsecaseProtocol {
    
    private let outputPort: PokedexListOutputPort
    private let repository: PokedexListRepositoryProtocol
    private var pokemonIDList: [PokemonID] = []
    
    internal init(
        outputPort: PokedexListOutputPort,
         repository: PokedexListRepositoryProtocol
    ) {
        self.outputPort = outputPort
        self.repository = repository
    }
    
    internal func request(_ request: PokedexListRequest) {

    }
    
//    private func handle(_ request: PokedexListRequest) async -> PokedexListResponse {
//        
//    }
    
}
