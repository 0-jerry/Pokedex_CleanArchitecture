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
    case setPokemonImageData(PokemonImageData)
    case pushPokemonInfo(PokemonID)
    case handleError(PokedexListUseCaseError)
}
