//
//  PokedexListUseCase.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

public protocol PokedexListUseCaseProtocol: AnyObject {
    func request(_ request: PokedexListRequest)
}

public enum PokedexListUseCaseError: Error {
    case offline
    case pokemonImageLoadFaild(PokemonID)
    case unknown
}

public protocol PokedexListOutputPort: AnyObject {
    func present(_ response: PokedexListResponse)
}

public protocol PokedexListRepositoryProtocol {
    func fetchPokemonIDList(offset: Int) async throws -> [PokemonID]
    func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData
}

public enum PokedexListRepositoryError: Error {
    case offline
}

public final class PokedexListUseCase: PokedexListUseCaseProtocol {
    private let outputPort: PokedexListOutputPort
    private let repository: PokedexListRepositoryProtocol
    
    public init(
        outputPort: PokedexListOutputPort,
        repository: PokedexListRepositoryProtocol
    ) {
        self.outputPort = outputPort
        self.repository = repository
    }
    
    public func request(_ request: PokedexListRequest) {
        switch request {
        case .fetchPokemonIDList(offset: let offset):
            handleFetchPokemonIDList(offset: offset)
            
        case .fetchPokemonImage(let pokemonID):
            handleFetchPokemonImage(pokemonID)
            
        case .selectedPokemon(let pokemonID):
            outputPort.present(.pushPokemonInfo(pokemonID))
        }
    }
    
    private func handleFetchPokemonIDList(offset: Int) {
        Task { [weak self] in
            do {
                guard let pokemonIDList = try await self?.repository.fetchPokemonIDList(offset: offset) else {
                    self?.outputPort.present(.handleError(.unknown))
                    return
                }
                self?.outputPort.present(.appendPokemonIDList(pokemonIDList))
            } catch PokedexListRepositoryError.offline {
                self?.outputPort.present(.handleError(.offline))
            } catch {
                self?.outputPort.present(.handleError(.unknown))
            }
        }
    }
    
    private func handleFetchPokemonImage(_ pokemonID: PokemonID) {
        Task { [weak self] in
            do {
                guard let repository = self?.repository else { return }
                let pokemonImageData = try await repository.fetchPokemonImage(pokemonID)
                self?.outputPort.present(.setPokemonImageData(pokemonImageData))
            } catch {
                self?.outputPort.present(.handleError(.pokemonImageLoadFaild(pokemonID)))
            }
        }
    }
    
}
