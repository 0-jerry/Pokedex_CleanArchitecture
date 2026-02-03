//
//  PokedexListPresneter.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import UIKit
import PokedexDomain

@MainActor
internal protocol PokedexListRouterProcotol: AnyObject {
    func assign(_ destination: PokedexListDestination)
}

@MainActor
internal protocol PokedexListRenderer: AnyObject {
    func render(_ viewModel: PokedexListViewModel)
}

enum PokedexListViewModel {
    case appendPokemonList([PokemonID])
    case setupPokemonImage(pokemonID: PokemonID, image: UIImage)
    case showErrorAlert(title: String, message: String)
}

enum PokedexListDestination {
    case pushPokemonInfo(PokemonID)
}

internal final class PokedexListPresneter: PokedexListOutputPort {
    
    private let router: PokedexListRouterProcotol
    private weak var renderer: (PokedexListRenderer)?
    
    internal init(
        router: PokedexListRouterProcotol,
        renderer: PokedexListRenderer?
    ) {
        self.router = router
        self.renderer = renderer
    }
    
    func present(_ response: PokedexListResponse) {
        let viewModel = convert(response)
        renderer?.render(viewModel)
    }
    
    private func convert(_ response: PokedexListResponse) -> PokedexListViewModel {
        <#code#>
    }
    
}
