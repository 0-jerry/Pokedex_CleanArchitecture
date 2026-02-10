//
//  StubPokeDTOParser.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

struct StubPokeDTOParser: PokeDTOParserProtocol {
    
    let tempPokemonIDList: [PokemonID] = Array(0...20)
    let tempPokemon: Pokemon = .init(id: 0, name: "test", types: [.bug],
                                 height: 10, weight: 10)
    
    func parsePokemonIDList(from dto: NamedAPIResourceList) async throws -> [PokemonID] {
        return tempPokemonIDList
    }
    
    func parsePokemon(from dto: PokemonDTO) async throws -> Pokemon {
        return tempPokemon
    }
    
}
