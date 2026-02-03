//
//  PokedexListResponse.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import Foundation.NSData

internal typealias PokemonImageData = Data

internal enum PokedexListResponse {
    case appendPokemonIDList([PokemonID])
    case setPokemonImage(pokemonID: PokemonID, imageData: PokemonImageData)
    case pushPokemonInfo(pokemonID: PokemonID)
    case handleError(_ error: Error)
}
