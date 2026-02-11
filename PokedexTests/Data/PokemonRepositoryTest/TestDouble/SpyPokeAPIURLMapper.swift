//
//  SpyPokeAPIURLMapper.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

import Foundation

struct PokemonIDListFetchParameter: Equatable {
    let offset: Int
    let limit: Int
}
final class SpyPokeAPIURLMapper: PokeAPIURLMapperProtocol {
    
    private(set) var fetchedPokemonListURLParameter: [PokemonIDListFetchParameter] = []
    private(set) var fetchedPokemonURLParameter: [PokemonID] = []
    private(set) var fetchedPokemonImageURLParameter: [PokemonID] = []

    let tempPokemonListURL = URL(string: "www.PokemonListURL.test")!
    let tempPokemonURL = URL(string: "www.PokemonURL.test")!
    let tempPokemonImageURL = URL(string: "www.PokemonImageURL.test")!
    
    func pokemonListURL(offset: Int, limit: Int) -> URL? {
        fetchedPokemonListURLParameter.append(PokemonIDListFetchParameter(offset: offset, limit: limit))
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
