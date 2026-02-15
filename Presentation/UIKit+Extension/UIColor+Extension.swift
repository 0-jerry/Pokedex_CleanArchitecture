//
//  UIColor+Extension.swift
//  Pokedex
//
//  Created by jerry on 2/13/26.
//

import UIKit.UIColor

extension UIColor {
    static func hex(_ hex: HEX) -> UIColor {
        UIColor(red: hex.red,
                green: hex.green,
                blue: hex.blue,
                alpha: hex.alpha)
    }
}
