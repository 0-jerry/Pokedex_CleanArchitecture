//
//  PokedexListResponse.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import Foundation.NSData

internal struct PokemonImageData {
    let pokemonID: PokemonID
    let data: Data
}

internal enum PokedexListResponse {
    case appendPokemonIDList([PokemonID])
    case setPokemonImage(imageData: PokemonImageData)
    case pushPokemonInfo(pokemonID: PokemonID)
    case handleError(_ error: Error)
}
