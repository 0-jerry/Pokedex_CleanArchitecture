//
//  PokemonRepository.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import Foundation
import PokedexDomain

protocol PokeAPIURLMapperProtocol {
    func pokemonListURL(offset: Int, limit: Int) -> URL?
    func pokemonInfoURL(for pokemonID: PokemonID) -> URL?
    func pokemonImageURL(for pokemonID: PokemonID) -> URL?
}

protocol NetworkStatusProviderProtocol {
    var isConnected: Bool { get }
}

protocol NetworkClientProtocol {
    func fetch<DTO: Decodable>(_ url: URL) async throws -> DTO
}

protocol CacheProtocol {
    func setValue<Value>(_ value: Value, forKey key: URL) async
    func value<Value>(forKey key: URL) async -> Value?
}

public final class PokemonRepository: PokedexListRepositoryProtocol {
    
    private let urlMapper: PokeAPIURLMapperProtocol = PokeAPIURLMapper()
    private let networkStatusProvider: NetworkStatusProviderProtocol
    private let networkClient: NetworkClientProtocol
    private let cache: CacheProtocol
    
    private var offset: Int = 0
    private let limit: Int = 21
    
    public init() {
        self.urlMapper = PokeAPIURLMapper()
        self.networkStatusProvider = DefaultNetworkStatusProvider()
        self.networkClient = URLSessionNetworkClient()
        self.cache = InMemoryCache()
    }
    
    internal init(
        networkStatusProvider: NetworkStatusProviderProtocol,
        networkClient: NetworkClientProtocol,
        cache: CacheProtocol
    ) {
        self.networkStatusProvider = networkStatusProvider
        self.networkClient = networkClient
        self.cache = cache
    }
    
    public func fetchPokemonIDList() async throws -> [PokemonID] {
    }
    
    public func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData {
    }
    
}
