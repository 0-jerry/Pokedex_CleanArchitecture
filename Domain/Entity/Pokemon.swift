//
//  PokedexDomain.swift
//  PokedexDomain
//
//  Created by jerry on 2/2/26.
//

public struct Pokemon {
    public let id: PokemonID
    public let name: String
    public let types: [PokemonType]
    public let height: Height
    public let weight: Weight
    
    public init(
        id: PokemonID,
        name: String,
        types: [PokemonType],
        height: Height,
        weight: Weight
    ) {
        self.id = id
        self.name = name
        self.types = types
        self.height = height
        self.weight = weight
    }
}
