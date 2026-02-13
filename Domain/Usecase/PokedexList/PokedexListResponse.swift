//
//  PokedexListResponse.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import Foundation.NSData

public struct PokemonImageData {
    public let pokemonID: PokemonID
    public let data: Data
    
    public init(pokemonID: PokemonID, data: Data) {
        self.pokemonID = pokemonID
        self.data = data
    }
}

public enum PokedexListResponse {
    case appendPokemonIDList([PokemonID])
    case setPokemonImage(imageData: PokemonImageData)
    case pushPokemonInfo(pokemonID: PokemonID)
    case handleError(_ error: PokedexListUseCaseError)
}
