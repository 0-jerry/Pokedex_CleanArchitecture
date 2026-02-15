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
    func setValue(_ value: Data, forKey key: String) async
    func value(forKey key: String) async -> Data?
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
    
    private let limit: Int
    
    public init(limit: Int = 21) {
        self.urlMapper = PokeAPIURLMapper()
        self.cache = InMemoryCache()
        self.networkStatusProvider = NetworkStatusProvider()
        self.networkClient = URLSessionNetworkClient()
        self.parser = PokeAPIParser()
        self.limit = limit
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
    
    public func fetchPokemonIDList(offset: Int) async throws -> [PokemonID] {
        guard let url = urlMapper.pokemonIDListURL(offset: offset, limit: limit) else {
            throw URLError(.unknown)
        }
        
        let fetchedData = try await fetchData(url)
        let pokemonIDList = try parser.pokemonIDList(data: fetchedData)

        return pokemonIDList
    }
    
    public func fetchPokemon(_ pokemonID: PokemonID) async throws -> Pokemon {
        guard let url = urlMapper.pokemonURL(for: pokemonID) else {
            throw URLError(.unknown)
        }
        
        let fetchedData = try await fetchData(url)
        let pokemon = try parser.pokemon(data: fetchedData)
        
        return pokemon
    }
    
    public func fetchPokemonImage(_ pokemonID: PokemonID) async throws -> PokemonImageData {
        guard let url = urlMapper.pokemonImageURL(for: pokemonID) else {
            throw URLError(.unknown)
        }
        
        let fetchedData = try await fetchData(url)
        let pokemonImageData = try parser.pokemonImageData(pokemonID: pokemonID, data: fetchedData)
        
        return pokemonImageData
    }
    
    private func fetchData(_ url: URL) async throws -> Data {
        let key = url.absoluteString
        
        if let cached = await cache.value(forKey: key) {
            return cached
        } else {
            guard networkStatusProvider.isConnected else {
                throw PokedexListRepositoryError.offline
            }
            let data = try await networkClient.fetch(url)
            
            Task { [weak self] in
                await self?.cache.setValue(data, forKey: key)
            }
            
            return data
        }
    }
    
}
