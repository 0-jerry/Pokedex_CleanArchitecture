//
//  PokeAPIURLMapper.swift
//  Pokedex
//
//  Created by jerry on 2/3/26.
//

import Foundation
import PokedexDomain

struct PokeAPIURLMapper: PokeAPIURLMapperProtocol {
    
    private static let baseURL: String = "https://pokeapi.co/api/v2"
    
    func pokemonIDListURL(offset: Int, limit: Int) -> URL? {
        let endPoint = "pokemon"
        let query = "?" + ["offset=\(offset)", "limit=\(limit)"].joined(separator: "&")
        let rawString = [Self.baseURL, endPoint, query].joined(separator: "/")
        
        return URL(string: rawString)
    }
    
    func pokemonURL(for pokemonID: PokemonID) -> URL? {
        let endPoint = "pokemon"
        let rawString = [Self.baseURL, endPoint, "\(pokemonID)"].joined(separator: "/")
        
        return URL(string: rawString)
    }
    
    func pokemonImageURL(for pokemonID: PokemonID) -> URL? {
        let rawString =  [
            "https://raw.githubusercontent.com/PokeAPI",
            "sprites/master/sprites/pokemon/other/official-artwork",
            "\(pokemonID).png"
        ].joined(separator: "/")
        
        return URL(string: rawString)
    }
    
}
