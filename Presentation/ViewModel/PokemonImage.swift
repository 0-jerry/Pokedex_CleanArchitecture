//
//  PokemonImage.swift
//  Pokedex
//
//  Created by jerry on 2/15/26.
//

import UIKit
import PokedexDomain

public struct PokemonImage {
    let pokemonID: Int
    let image: UIImage
    
    init?(pokemonImageData: PokemonImageData) {
        guard let pokemonImage = UIImage(data: pokemonImageData.data) else {
            return nil
        }
        self.pokemonID = pokemonImageData.pokemonID
        self.image = pokemonImage
    }
}
