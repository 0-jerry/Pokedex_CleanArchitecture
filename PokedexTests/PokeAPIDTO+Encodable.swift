import Foundation

extension PokemonDTO: Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(types, forKey: .types)
        try container.encode(height, forKey: .height)
        try container.encode(weight, forKey: .weight)
    }

    enum CodingKeys: String, CodingKey {
        case id, name, types, height, weight
    }
}

extension PokemonTypeDTO: Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(slot, forKey: .slot)
        try container.encode(type, forKey: .type)
    }

    enum CodingKeys: String, CodingKey {
        case slot, type
    }
    
}

extension NamedAPIResource: Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
    }

    enum CodingKeys: String, CodingKey {
        case name, url
    }
}

extension NamedAPIResourceList: Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(results, forKey: .results)
    }

    enum CodingKeys: String, CodingKey {
        case results
    }
}

extension Encodable {
    var data: Data {
        try! JSONEncoder().encode(self)
    }
}
