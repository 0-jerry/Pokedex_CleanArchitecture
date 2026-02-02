//
//  PokedexListRouter.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import UIKit
import PokedexDomain

internal final class PokedexListRouter: PokedexListRouterProcotol {
    
    private weak var navigationController: UINavigationController?
    
    internal init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func push(_ pokemonID: PokemonID) {
        <#code#>
    }
    
}
