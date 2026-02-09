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
        <#code#>
    }
    
}
