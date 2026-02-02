//
//  PokedexListRequest.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

internal enum PokedexListRequest {
    case fetchPokemonList
    case fetchPokemonImage(PokemonID)
    case selectedPokemon(PokemonID)
}
