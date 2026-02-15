//
//  Factory.swift
//  Pokedex
//
//  Created by jerry on 2/13/26.
//

import UIKit
import PokedexDomain
import PokedexData
import PokedexPresentation

enum PokedexListFactory {
    
    static func pokedexList(_ navigationController: UINavigationController) -> PokedexListView {
        let view = PokedexListView()
        let router = PokedexListRouter(navigationController: navigationController)
        let presenter = PokedexListPresenter(router: router,
                                             renderer: view)
        let useCase = PokedexListUseCase(outputPort: presenter,
                                         repository: PokemonRepository())
        let controller = PokedexListController(useCase: useCase)
        
        view.input = controller
        
        return view
    }
    
}
