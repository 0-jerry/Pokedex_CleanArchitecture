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
    case pokemonIDListIsOnloading
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

public final class PokedexListUseCase: PokedexListUseCaseProtocol {
    private let outputPort: PokedexListOutputPort
    private let repository: PokedexListRepositoryProtocol
    
    private var pokemonIDListIsOnloading: Bool = false

    public init(
        outputPort: PokedexListOutputPort,
        repository: PokedexListRepositoryProtocol
    ) {
        self.outputPort = outputPort
        self.repository = repository
    }
    
    public func request(_ request: PokedexListRequest) {
        switch request {
        case .fetchPokemonIDList:
            handleFetchPokemonIDList()
            
        case .fetchPokemonImage(let pokemonID):
            handleFetchPokemonImage(pokemonID)
            
        case .selectedPokemon(let pokemonID):
            outputPort.present(.pushPokemonInfo(pokemonID: pokemonID))
        }
    }
    
    private func handleFetchPokemonIDList() {
        Task { [weak self] in
            guard let self, !self.pokemonIDListIsOnloading else {
                self?.outputPort.present(.handleError(.pokemonIDListIsOnloading))
                return
            }
            
            self.pokemonIDListIsOnloading = true
            defer { self.pokemonIDListIsOnloading = false }
            
            do {
                let pokemonIDList = try await self.repository.fetchPokemonIDList()
                self.outputPort.present(.appendPokemonIDList(pokemonIDList))
            } catch PokedexListRepositoryError.offline {
                self.outputPort.present(.handleError(.offline))
            } catch {
                self.outputPort.present(.handleError(.unknown))
            }
        }
    }
    
    private func handleFetchPokemonImage(_ pokemonID: PokemonID) {
        Task { [weak self] in
            do {
                guard let repository = self?.repository else { return }
                let pokemonImageData = try await repository.fetchPokemonImage(pokemonID)
                self?.outputPort.present(.setPokemonImage(imageData: pokemonImageData))
            } catch {
                self?.outputPort.present(.handleError(.pokemonImageLoadFaild(pokemonID)))
            }
        }
    }
    
}
