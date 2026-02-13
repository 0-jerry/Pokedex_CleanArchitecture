//
//  Weight.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

public struct Weight {
    public let unit: WeightUnit
    public let amount: Int
    
    public init(unit: WeightUnit, amount: Int) {
        self.unit = unit
        self.amount = amount
    }
}

public enum WeightUnit {
    case hectogram
}
