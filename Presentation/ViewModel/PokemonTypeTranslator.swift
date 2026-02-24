//
//  PokemonTypeTranslator.swift
//  Pokedex
//
//  Created by jerry on 2/24/26.
//

import PokedexDomain

enum PokemonTypeTranslator {
    
    // Static values for background colors in HEX format
    static let normalColor = HEX(red: 255, green: 255, blue: 255, alpha: 1.0) // White
    static let fightingColor = HEX(red: 190, green: 30, blue: 40, alpha: 1.0) // Red
    static let flyingColor = HEX(red: 173, green: 216, blue: 230, alpha: 1.0) // Light Blue
    static let poisonColor = HEX(red: 128, green: 0, blue: 128, alpha: 1.0) // Purple
    static let groundColor = HEX(red: 255, green: 255, blue: 0, alpha: 1.0) // Yellow
    static let rockColor = HEX(red: 169, green: 169, blue: 169, alpha: 1.0) // Gray
    static let bugColor = HEX(red: 0, green: 255, blue: 0, alpha: 1.0) // Green
    static let ghostColor = HEX(red: 0, green: 0, blue: 0, alpha: 1.0) // Black
    static let steelColor = HEX(red: 169, green: 169, blue: 169, alpha: 1.0) // Gray
    static let fireColor = HEX(red: 190, green: 30, blue: 40, alpha: 1.0) // Red
    static let waterColor = HEX(red: 0, green: 0, blue: 255, alpha: 1.0) // Blue
    static let grassColor = HEX(red: 0, green: 255, blue: 0, alpha: 1.0) // Green
    static let electricColor = HEX(red: 255, green: 255, blue: 0, alpha: 1.0) // Yellow
    static let psychicColor = HEX(red: 128, green: 0, blue: 128, alpha: 1.0) // Purple
    static let iceColor = HEX(red: 173, green: 216, blue: 230, alpha: 1.0) // Light Blue
    static let dragonColor = HEX(red: 190, green: 30, blue: 40, alpha: 1.0) // Red
    static let darkColor = HEX(red: 0, green: 0, blue: 0, alpha: 1.0) // Black
    static let fairyColor = HEX(red: 255, green: 105, blue: 180, alpha: 1.0) // Pink
    static let stellarColor = HEX(red: 0, green: 0, blue: 255, alpha: 1.0) // Blue
    static let unknownColor = HEX(red: 255, green: 255, blue: 255, alpha: 1.0) // White
    static let shadowColor = HEX(red: 0, green: 0, blue: 0, alpha: 1.0) // Black
    
    static func translate(_ type: PokemonType) -> FormattedPokemonType {
        switch type {
        case .normal:
            return FormattedPokemonType(string: "Normal", backgroundColor: normalColor)
        case .fighting:
            return FormattedPokemonType(string: "Fighting", backgroundColor: fightingColor)
        case .flying:
            return FormattedPokemonType(string: "Flying", backgroundColor: flyingColor)
        case .poison:
            return FormattedPokemonType(string: "Poison", backgroundColor: poisonColor)
        case .ground:
            return FormattedPokemonType(string: "Ground", backgroundColor: groundColor)
        case .rock:
            return FormattedPokemonType(string: "Rock", backgroundColor: rockColor)
        case .bug:
            return FormattedPokemonType(string: "Bug", backgroundColor: bugColor)
        case .ghost:
            return FormattedPokemonType(string: "Ghost", backgroundColor: ghostColor)
        case .steel:
            return FormattedPokemonType(string: "Steel", backgroundColor: steelColor)
        case .fire:
            return FormattedPokemonType(string: "Fire", backgroundColor: fireColor)
        case .water:
            return FormattedPokemonType(string: "Water", backgroundColor: waterColor)
        case .grass:
            return FormattedPokemonType(string: "Grass", backgroundColor: grassColor)
        case .electric:
            return FormattedPokemonType(string: "Electric", backgroundColor: electricColor)
        case .psychic:
            return FormattedPokemonType(string: "Psychic", backgroundColor: psychicColor)
        case .ice:
            return FormattedPokemonType(string: "Ice", backgroundColor: iceColor)
        case .dragon:
            return FormattedPokemonType(string: "Dragon", backgroundColor: dragonColor)
        case .dark:
            return FormattedPokemonType(string: "Dark", backgroundColor: darkColor)
        case .fairy:
            return FormattedPokemonType(string: "Fairy", backgroundColor: fairyColor)
        case .stellar:
            return FormattedPokemonType(string: "Stellar", backgroundColor: stellarColor)
        case .unknown:
            return FormattedPokemonType(string: "Unknown", backgroundColor: unknownColor)
        case .shadow:
            return FormattedPokemonType(string: "Shadow", backgroundColor: shadowColor)
        @unknown default:
            fatalError("Unknown Pokemon type")
        }
    }
}
