//
//  PokedexListRepository.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import PokedexDomain
import Foundation

protocol NetworkStatusProviderProtocol {
    var isConnected: Bool { get }
}

protocol PokedexNetworkClientProtocol {
    func fetchPokemonIDList(_ offset: Int, _ limit: Int) async throws -> NamedAPIResourceList
    func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> Data
}

final class PokedexListRepository: PokedexListRepositoryProtocol {
    
    private let networkStatusProvider: NetworkStatusProviderProtocol
    private let networkClient: PokedexNetworkClientProtocol
    
    init(
        networkStatusProvider: NetworkStatusProviderProtocol,
        networkClient: PokedexNetworkClientProtocol,
    ) {
        self.networkStatusProvider = networkStatusProvider
        self.networkClient = networkClient
    }
    
    func fetchPokemonID(_ offset: Int) async throws -> [PokemonID] {
        <#code#>
    }
    
    func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData {
        <#code#>
    }
    
}

