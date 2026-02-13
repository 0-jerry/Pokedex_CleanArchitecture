//
//  PokeAPIParser.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import Foundation
import PokedexDomain

struct PokeAPIParser: PokeAPIParserProtocol {
    
    func pokemonIDList(data: Data) throws -> [PokemonID] {
        guard let dto = try JSONDecoder().decode(NamedAPIResourceList.self, from: data).results else {
            throw NSError(domain: "\(Self.self) \(#function) - Invalid Data", code: -1)
        }
        return dto.compactMap { pokemonID($0) }
    }
    
    func pokemon(data: Data) throws -> Pokemon {
        let dto = try JSONDecoder().decode(PokemonDTO.self, from: data)
        guard let id = dto.id,
              let name = dto.name,
              let rawType = dto.types,
              let rawHeight = dto.height,
              let rawWeight = dto.weight else {
            throw NSError(domain: "\(Self.self) \(#function) - Invalid Data", code: -1)
        }
        
        let type: [PokemonType] = rawType.compactMap { pokemonType($0) }
        let height = Height(unit: .decimeter, amount: rawHeight)
        let weight = Weight(unit: .hectogram, amount: rawWeight)
        
        return Pokemon(id: id, name: name, types: type, height: height, weight: weight)
    }
    
    func pokemonImageData(pokemonID: PokemonID, data: Data) throws -> PokemonImageData {
        PokemonImageData(pokemonID: pokemonID, data: data)
    }
    
}

extension PokeAPIParser {
    
    private func pokemonID(_ rawValue: NamedAPIResource) -> PokemonID? {
        guard var url = rawValue.url else { return nil }
        url.removeLast()
        guard let raw = url.components(separatedBy: "/").last else { return nil }

        return Int(raw)
    }
    
    private func pokemonType(_ rawValue: PokemonTypeDTO) -> PokemonType? {
        guard let rawValue = rawValue.type?.name else {
            return nil
        }
        
        switch rawValue {
        case "normal": return .normal
        case "fighting": return .fighting
        case "flying": return .flying
        case "poison": return .poison
        case "ground": return .ground
        case "rock": return .rock
        case "bug": return .bug
        case "ghost": return .ghost
        case "steel": return .steel
        case "fire": return .fire
        case "water": return .water
        case "grass": return .grass
        case "electric": return .electric
        case "psychic": return .psychic
        case "ice": return .ice
        case "dragon": return .dragon
        case "dark": return .dark
        case "fairy": return .fairy
        case "stellar": return .stellar
        case "unknown": return .unknown
        case "shadow": return .shadow
        default: return nil
        }
    }
}
