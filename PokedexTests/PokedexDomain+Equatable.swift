//
//  PokedexDomain+Equatable.swift
//  Pokedex
//
//  Created by jerry on 2/11/26.
//

extension Pokemon: Equatable {
    public static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}

extension PokemonImageData: Equatable {
    public static func == (lhs: PokemonImageData, rhs: PokemonImageData) -> Bool {
        lhs.pokemonID == rhs.pokemonID && lhs.data == rhs.data
    }
}
