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
    func pokemonURL(for pokemonID: PokemonID) -> URL?
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

protocol PokeDTOParserProtocol {
    func parsePokemonIDList(from dto: NamedAPIResourceList) async throws -> [PokemonID]
    func parsePokemon(from dto: PokemonDTO) async throws -> Pokemon
}

public final class PokemonRepository: PokedexListRepositoryProtocol, PokemonInfoRepositoryProtocol {
    
    private let urlMapper: PokeAPIURLMapperProtocol
    private let cache: CacheProtocol
    private let networkStatusProvider: NetworkStatusProviderProtocol
    private let networkClient: NetworkClientProtocol
    private let parser: PokeDTOParserProtocol
    
    private var offset: Int = 0
    private let limit: Int
    
    public init(limit: Int = 21) {
        self.urlMapper = PokeAPIURLMapper()
        self.cache = InMemoryCache()
        self.networkStatusProvider = NetworkStatusProvider()
        self.networkClient = URLSessionNetworkClient()
        self.parser = PokeDTOParser()
        self.limit = 21
    }
    
    internal init(
        urlMapper: PokeAPIURLMapperProtocol,
        cache: CacheProtocol,
        networkStatusProvider: NetworkStatusProviderProtocol,
        networkClient: NetworkClientProtocol,
        parser: PokeDTOParserProtocol,
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
