//
//  PokedexListRepository.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import Foundation
import PokedexDomain

protocol NetworkStatusProviderProtocol {
    var isConnected: Bool { get }
}

protocol NetworkClientProtocol {
    func fetch<DTO: Decodable>(_ url: URL) async throws -> DTO
}

final class PokedexListRepository: PokedexListRepositoryProtocol {

    private let networkStatusProvider: NetworkStatusProviderProtocol
    private let networkClient: NetworkClientProtocol
    
    private var offset: Int = 0
    private let limit: Int = 21
    
    init(
        networkStatusProvider: NetworkStatusProviderProtocol,
        networkClient: NetworkClientProtocol,
    ) {
        self.networkStatusProvider = networkStatusProvider
        self.networkClient = networkClient
    }
    
    func fetchPokemonIDList() async throws -> [PokemonID] {
    }
    
    func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData {
    }
    
}
