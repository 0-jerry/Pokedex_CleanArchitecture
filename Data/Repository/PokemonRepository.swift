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
        let pokemonIDList: [PokemonID]
        
        var nextOffset = offset
        defer { offset = nextOffset }
        
        guard let url = urlMapper.pokemonIDListURL(offset: offset, limit: limit) else {
            throw URLError(.unknown)
        }
        
        if let cached: [PokemonID] = await cache.value(forKey: url) {
            pokemonIDList = cached
        } else {
            let data = try await fetchData(url)
            pokemonIDList = try parser.pokemonIDList(data: data)
            await cache.setValue(pokemonIDList, forKey: url)
        }
        
        nextOffset += pokemonIDList.count
        return pokemonIDList
    }
    
    public func fetchPokemon(_ pokemonID: PokemonID) async throws -> Pokemon {
        guard let url = urlMapper.pokemonURL(for: pokemonID) else {
            throw URLError(.unknown)
        }
        
        if let cached: Pokemon = await cache.value(forKey: url) {
            return cached
        } else {
            let data = try await fetchData(url)
            let pokemon = try parser.pokemon(data: data)
            await cache.setValue(pokemon, forKey: url)
            
            return pokemon
        }
    }
    
    public func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData {
        guard let url = urlMapper.pokemonImageURL(for: pokemonID) else {
            throw URLError(.unknown)
        }
        if let cached: PokemonImageData = await cache.value(forKey: url) {
            return cached
        } else {
            let data = try await fetchData(url)
            let pokemonImageData = try parser.pokemonImageData(pokemonID: pokemonID, data: data)
            await cache.setValue(pokemonImageData, forKey: url)
            
            return pokemonImageData
        }
    }
    
    private func fetchData(_ url: URL) async throws -> Data {
        guard networkStatusProvider.isConnected else {
            throw PokedexListRepositoryError.offline
        }
        let result = try await networkClient.fetch(url)
        return result
    }
    
}
