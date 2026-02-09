//
//  PokemonInfoUseCase.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

public protocol PokemonInfoUseCaseProtocol {
    func request(_ request: PokemonInfoRequest)
                 
}

public protocol PokemonInfoOutputPort: AnyObject {
    func present(_ response: PokemonInfoResponse)
}

public protocol PokemonInfoRepositoryProtocol {
    func fetchPokemon(_ pokemonID: PokemonID) async throws -> Pokemon
    func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData
}

public final class PokemonInfoUseCase: PokemonInfoUseCaseProtocol {
    
    private let output: PokemonInfoOutputPort
    private let repository: PokemonInfoRepositoryProtocol
    
    public init(
        output: PokemonInfoOutputPort,
        repository: PokemonInfoRepositoryProtocol
    ) {
        self.output = output
        self.repository = repository
    }
    
    public func request(_ request: PokemonInfoRequest) {
        <#code#>
    }
}
