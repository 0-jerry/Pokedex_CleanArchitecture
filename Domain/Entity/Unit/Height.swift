//
//  Height.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

public struct Height {
    public let unit: HeightUnit
    public let amount: Int
    
    public init(unit: HeightUnit, amount: Int) {
        self.unit = unit
        self.amount = amount
    }
}

public enum HeightUnit {
    case decimeter
}
