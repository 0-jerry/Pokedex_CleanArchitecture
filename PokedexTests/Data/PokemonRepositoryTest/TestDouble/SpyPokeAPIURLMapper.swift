//
//  SpyPokeAPIURLMapper.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

import Foundation

final class SpyPokeAPIURLMapper: PokeAPIURLMapperProtocol {
    
    private(set) var fetchedPokemonListURLParameter: [(offset: Int, limit: Int)] = []
    private(set) var fetchedPokemonURLParameter: [PokemonID] = []
    private(set) var fetchedPokemonImageURLParameter: [PokemonID] = []

    private(set) var tempPokemonListURL: URL! = URL(string: "www.PokemonListURL.test")
    private(set) var tempPokemonURL: URL! = URL(string: "www.PokemonURL.test")
    private(set) var tempPokemonImageURL: URL! = URL(string: "www.PokemonImageURL.test")
    
    func pokemonListURL(offset: Int, limit: Int) -> URL? {
        fetchedPokemonListURLParameter.append((offset, limit))
        return tempPokemonListURL
    }
    
    func pokemonURL(for pokemonID: PokemonID) -> URL? {
        fetchedPokemonURLParameter.append(pokemonID)
        return tempPokemonURL
    }
    
    func pokemonImageURL(for pokemonID: PokemonID) -> URL? {
        fetchedPokemonImageURLParameter.append(pokemonID)
        return tempPokemonImageURL
    }
    
}
