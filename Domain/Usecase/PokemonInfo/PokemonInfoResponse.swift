//
//  PokemonInfoResponse.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

public enum PokemonInfoResponse {
    case pokemonInfo(pokemon: Pokemon, pokemonImageData: PokemonImageData)
    case dismiss
    case error(PokemonInfoUseCaseError)
}
