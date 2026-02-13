//
//  StubPokeAPIParser.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

import Foundation

final class StubPokeAPIParser: PokeAPIParserProtocol {
    
    func pokemon(data: Data) throws -> Pokemon {
        guard let pokemon = tempPokemon else {
            throw NSError(domain: "StubPokeAPIParser_pokemon", code: -1)
        }
        return pokemon
    }
    
    func pokemonIDList(data: Data) throws -> [PokemonID] {
        guard let pokemonIDList = tempPokemonIDList else {
            throw NSError(domain: "StubPokeAPIParser_pokemonIDList", code: -1)
        }
        return pokemonIDList
    }
    
    func pokemonImageData(pokemonID: PokemonID, data: Data) throws -> PokemonImageData {
        guard let pokemonImageData = tempPokemonImageData else {
            throw NSError(domain: "StubPokeAPIParser_pokemonImageData", code: -1)
        }
        return pokemonImageData
    }
    
    var tempPokemonImageData: PokemonImageData?
    var tempPokemonIDList: [PokemonID]?
    var tempPokemon: Pokemon?
}
