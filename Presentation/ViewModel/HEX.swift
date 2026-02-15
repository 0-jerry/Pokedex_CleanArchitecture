//
//  HEX.swift
//  Pokedex
//
//  Created by jerry on 2/13/26.
//

struct HEX {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: Double) {
        self.red = Double(red) / 255
        self.green = Double(green) / 255
        self.blue = Double(blue) / 255
        self.alpha = min(max(alpha, 0), 1)
    }
    
    
    
    static let primaryRed = HEX(red: 190,
                             green: 30,
                             blue: 40,
                             alpha: 1.0)
    
    static let secondaryRed = HEX(red: 120,
                             green: 30,
                             blue: 30,
                             alpha: 1.0)
    
    static let primaryWhite = HEX(red: 245,
                                  green: 245,
                                  blue: 235,
                                  alpha: 1.0)
}
