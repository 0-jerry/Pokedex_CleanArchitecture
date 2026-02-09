//
//  PokedexListUsecase.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

public protocol PokedexListUsecaseProtocol: AnyObject {
    func request(_ request: PokedexListRequest)
}
public enum PokedexListUsecaseError: Error {
    case offline
    case pokemonImageLoadFaild(PokemonID)
    case unknown
}

public protocol PokedexListOutputPort: AnyObject {
    func present(_ response: PokedexListResponse)
}

public protocol PokedexListRepositoryProtocol {
    func fetchPokemonIDList() async throws -> [PokemonID]
    func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData
}
public enum PokedexListRepositoryError: Error {
    case offline
}

public final class PokedexListUsecase: PokedexListUsecaseProtocol {
    
    private let outputPort: PokedexListOutputPort
    private let repository: PokedexListRepositoryProtocol
    private var pokemonIDList: [PokemonID] = []
    
    public init(
        outputPort: PokedexListOutputPort,
         repository: PokedexListRepositoryProtocol
    ) {
        self.outputPort = outputPort
        self.repository = repository
    }
    
    public func request(_ request: PokedexListRequest) {

    }
    
//    private func handle(_ request: PokedexListRequest) async -> PokedexListResponse {
//        
//    }
    
}
