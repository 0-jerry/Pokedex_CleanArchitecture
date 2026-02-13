//
//  PokemonRepository.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import Foundation
import PokedexDomain

protocol PokeAPIURLMapperProtocol {
    func pokemonIDListURL(offset: Int, limit: Int) -> URL?
    func pokemonURL(for pokemonID: PokemonID) -> URL?
    func pokemonImageURL(for pokemonID: PokemonID) -> URL?
}

protocol CacheProtocol {
    func setValue<Value>(_ value: Value, forKey key: URL) async
    func value<Value>(forKey key: URL) async -> Value?
}

protocol NetworkStatusProviderProtocol {
    var isConnected: Bool { get }
}

protocol NetworkClientProtocol {
    func fetch(_ url: URL) async throws -> Data
}

protocol PokeAPIParserProtocol {
    func pokemonIDList(data: Data) throws -> [PokemonID]
    func pokemon(data: Data) throws -> Pokemon
    func pokemonImageData(pokemonID: PokemonID, data: Data) throws -> PokemonImageData
}

public final class PokemonRepository: PokedexListRepositoryProtocol, PokemonInfoRepositoryProtocol {
    private let urlMapper: PokeAPIURLMapperProtocol
    private let cache: CacheProtocol
    private let networkStatusProvider: NetworkStatusProviderProtocol
    private let networkClient: NetworkClientProtocol
    private let parser: PokeAPIParserProtocol
    
    private var offset: Int = 0
    private let limit: Int
    
    public init(limit: Int = 21) {
        self.urlMapper = PokeAPIURLMapper()
        self.cache = InMemoryCache()
        self.networkStatusProvider = NetworkStatusProvider()
        self.networkClient = URLSessionNetworkClient()
        self.parser = PokeAPIParser()
        self.limit = 21
    }
    
    internal init(
        urlMapper: PokeAPIURLMapperProtocol,
        cache: CacheProtocol,
        networkStatusProvider: NetworkStatusProviderProtocol,
        networkClient: NetworkClientProtocol,
        parser: PokeAPIParserProtocol,
        limit: Int
    ) {
        self.urlMapper = urlMapper
        self.cache = cache
        self.networkStatusProvider = networkStatusProvider
        self.networkClient = networkClient
        self.parser = parser
        self.limit = limit
    }
    
    public func fetchPokemonIDList() async throws -> [PokemonID] {
    }
    
    public func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData {
    }
    
    public func fetchPokemon(_ pokemonID: PokemonID) async throws -> Pokemon {
        <#code#>
    }
    
}
