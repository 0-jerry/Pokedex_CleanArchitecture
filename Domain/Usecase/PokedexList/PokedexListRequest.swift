//
//  PokedexListRequest.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

public enum PokedexListRequest {
    case fetchPokemonIDList
    case fetchPokemonImage(PokemonID)
    case selectedPokemon(PokemonID)
}
