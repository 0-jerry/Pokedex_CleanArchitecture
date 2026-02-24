//
//  PokemonTypeTranslator.swift
//  Pokedex
//
//  Created by jerry on 2/24/26.
//

import PokedexDomain

public enum PokemonTypeTranslator {
    // 공식 포켓몬 타입 색상을 반영한 HEX 값 정의
        static let normalColor = HEX(red: 168, green: 167, blue: 122, alpha: 1.0)   // #A8A77A
        static let fireColor = HEX(red: 238, green: 129, blue: 48, alpha: 1.0)      // #EE8130
        static let waterColor = HEX(red: 99, green: 144, blue: 240, alpha: 1.0)     // #6390F0
        static let electricColor = HEX(red: 247, green: 208, blue: 44, alpha: 1.0)  // #F7D02C
        static let grassColor = HEX(red: 122, green: 199, blue: 76, alpha: 1.0)     // #7AC74C
        static let iceColor = HEX(red: 150, green: 217, blue: 214, alpha: 1.0)      // #96D9D6
        static let fightingColor = HEX(red: 194, green: 46, blue: 40, alpha: 1.0)   // #C22E28
        static let poisonColor = HEX(red: 163, green: 62, blue: 161, alpha: 1.0)    // #A33EA1
        static let groundColor = HEX(red: 226, green: 191, blue: 101, alpha: 1.0)   // #E2BF65
        static let flyingColor = HEX(red: 169, green: 143, blue: 243, alpha: 1.0)   // #A98FF3
        static let psychicColor = HEX(red: 249, green: 85, blue: 135, alpha: 1.0)   // #F95587
        static let bugColor = HEX(red: 166, green: 185, blue: 26, alpha: 1.0)       // #A6B91A
        static let rockColor = HEX(red: 182, green: 161, blue: 54, alpha: 1.0)      // #B6A136
        static let ghostColor = HEX(red: 115, green: 87, blue: 151, alpha: 1.0)     // #735797
        static let dragonColor = HEX(red: 111, green: 53, blue: 252, alpha: 1.0)    // #6F35FC
        static let darkColor = HEX(red: 112, green: 88, blue: 72, alpha: 1.0)       // #705848
        static let steelColor = HEX(red: 183, green: 183, blue: 206, alpha: 1.0)    // #B7B7CE
        static let fairyColor = HEX(red: 214, green: 133, blue: 173, alpha: 1.0)    // #D685AD
        
        // 특수 타입 (스텔라, 알 수 없음, 섀도우)
        static let stellarColor = HEX(red: 64, green: 181, blue: 165, alpha: 1.0)   // #40B5A5 (청록계열)
        static let unknownColor = HEX(red: 104, green: 160, blue: 144, alpha: 1.0)  // #68A090
        static let shadowColor = HEX(red: 73, green: 57, blue: 99, alpha: 1.0)      // #493963
    public static func translate(_ type: PokemonType) -> FormattedPokemonType {
        switch type {
        case .normal:
            return FormattedPokemonType(string: "노말", backgroundColor: normalColor)
        case .fighting:
            return FormattedPokemonType(string: "격투", backgroundColor: fightingColor)
        case .flying:
            return FormattedPokemonType(string: "비행", backgroundColor: flyingColor)
        case .poison:
            return FormattedPokemonType(string: "독", backgroundColor: poisonColor)
        case .ground:
            return FormattedPokemonType(string: "땅", backgroundColor: groundColor)
        case .rock:
            return FormattedPokemonType(string: "바위", backgroundColor: rockColor)
        case .bug:
            return FormattedPokemonType(string: "벌레", backgroundColor: bugColor)
        case .ghost:
            return FormattedPokemonType(string: "고스트", backgroundColor: ghostColor)
        case .steel:
            return FormattedPokemonType(string: "강철", backgroundColor: steelColor)
        case .fire:
            return FormattedPokemonType(string: "불꽃", backgroundColor: fireColor)
        case .water:
            return FormattedPokemonType(string: "물", backgroundColor: waterColor)
        case .grass:
            return FormattedPokemonType(string: "풀", backgroundColor: grassColor)
        case .electric:
            return FormattedPokemonType(string: "전기", backgroundColor: electricColor)
        case .psychic:
            return FormattedPokemonType(string: "에스퍼", backgroundColor: psychicColor)
        case .ice:
            return FormattedPokemonType(string: "얼음", backgroundColor: iceColor)
        case .dragon:
            return FormattedPokemonType(string: "드래곤", backgroundColor: dragonColor)
        case .dark:
            return FormattedPokemonType(string: "악", backgroundColor: darkColor)
        case .fairy:
            return FormattedPokemonType(string: "페어리", backgroundColor: fairyColor)
        case .stellar:
            return FormattedPokemonType(string: "스텔라", backgroundColor: stellarColor)
        case .unknown:
            return FormattedPokemonType(string: "???", backgroundColor: unknownColor)
        case .shadow:
            return FormattedPokemonType(string: "섀도우", backgroundColor: shadowColor)
        }
    }
}
