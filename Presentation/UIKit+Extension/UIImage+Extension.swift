//
//  UIImage+Extension.swift
//  Pokedex
//
//  Created by jerry on 2/13/26.
//

import UIKit.UIImage
import PokedexDomain

extension UIImage {
    static func pokemonImage(_ pokemonImageData: PokemonImageData) -> UIImage? {
        UIImage(data: pokemonImageData.data)
    }
}
