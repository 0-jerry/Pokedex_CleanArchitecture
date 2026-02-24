//
//  PokedexListRouter.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import UIKit
import PokedexDomain

public final class PokedexListRouter: PokedexListRouterProcotol {

    private weak var navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    public func assign(_ destination: PokedexListDestination) {
        
        switch destination {
        case .pushPokemonInfo(let pokemonID):
            Task { @MainActor [weak navigationController] in
                guard let navigationController else { return }
                let nextView = PokemonInfoFactory.pokemonInfo(navigationController, pokemonID: pokemonID)
                navigationController.pushViewController(nextView, animated: true)
            }
        }
    }
    
}
