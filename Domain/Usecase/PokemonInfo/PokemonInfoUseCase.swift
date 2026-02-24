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

public enum PokemonInfoUseCaseError: Error {
    case offline
    case unknown
}

public final class PokemonInfoUseCase: PokemonInfoUseCaseProtocol {
    
    private let pokemonID: PokemonID
    private let output: PokemonInfoOutputPort
    private let repository: PokemonInfoRepositoryProtocol
    
    public init(
        pokemonID: PokemonID,
        output: PokemonInfoOutputPort,
        repository: PokemonInfoRepositoryProtocol
    ) {
        self.pokemonID = pokemonID
        self.output = output
        self.repository = repository
    }
    
    public func request(_ request: PokemonInfoRequest) {
        switch request {
        case .loadPokemonInfo:
            Task { [weak self] in
                guard let pokemonID = self?.pokemonID,
                      let repository = self?.repository else { return }
                do {
                    let pokemon = try await repository.fetchPokemon(pokemonID)
                    let pokemonImageData = try await repository.fetchPokemonImage(pokemonID)
                    
                    self?.output.present(.pokemonInfo(pokemon: pokemon,
                                                      pokemonImageData: pokemonImageData))
                    
                } catch PokedexRepositoryError.offline {
                    self?.output.present(.error(.offline))
                    
                } catch {
                    self?.output.present(.error(.unknown))
                    
                }
            }
            
        case .dismiss:
            output.present(.dismiss)
        }
    }
}
