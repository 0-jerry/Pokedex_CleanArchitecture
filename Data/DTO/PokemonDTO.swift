//
//  PokedexData.swift
//  PokedexData
//
//  Created by jerry on 2/2/26.
//

struct PokemonDTO: Decodable {
    let id: Int?
    let name: String?
    let types: [PokemonTypeDTO]?
    let height: Int?
    let weight: Int?
}
