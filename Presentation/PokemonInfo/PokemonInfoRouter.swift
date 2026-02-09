//
//  PokemonInfoRouter.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import UIKit

public final class PokemonInfoRouter: PokemonInfoRouterProcotol {
    
    private weak var navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func assign(_ destination: PokemonInfoDestination) {
        <#code#>
    }

}
