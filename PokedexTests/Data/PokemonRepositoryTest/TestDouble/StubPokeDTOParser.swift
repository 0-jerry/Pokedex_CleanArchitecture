//
//  StubPokeDTOParser.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

struct StubPokeDTOParser: PokeDTOParserProtocol {
    
    var tempPokemonIDList: [PokemonID]!
    var tempPokemon: Pokemon!
    
    func parsePokemonIDList(from dto: NamedAPIResourceList) async throws -> [PokemonID] {
        return tempPokemonIDList
    }
    
    func parsePokemon(from dto: PokemonDTO) async throws -> Pokemon {
        return tempPokemon
    }
    
}
