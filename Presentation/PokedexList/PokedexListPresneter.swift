//
//  PokedexListPresneter.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import UIKit
import PokedexDomain

@MainActor
public protocol PokedexListRouterProcotol: AnyObject {
    func assign(_ destination: PokedexListDestination)
}

@MainActor
public protocol PokedexListRenderer: AnyObject {
    func render(_ viewModel: PokedexListViewModel)
}

public enum PokedexListViewModel {
    case appendPokemonList([PokemonID])
    case setupPokemonImage(pokemonID: PokemonID, image: UIImage)
    case showErrorAlert(title: String, message: String)
}

public enum PokedexListDestination {
    case pushPokemonInfo(PokemonID)
}

public final class PokedexListPresneter: PokedexListOutputPort {
    
    private let router: PokedexListRouterProcotol
    private weak var renderer: (PokedexListRenderer)?
    
    public init(
        router: PokedexListRouterProcotol,
        renderer: PokedexListRenderer?
    ) {
        self.router = router
        self.renderer = renderer
    }
    
    public func present(_ response: PokedexListResponse) {
        let viewModel = convert(response)
        Task { [weak renderer] in
            await renderer?.render(viewModel)
        }
    }
    
    private func convert(_ response: PokedexListResponse) -> PokedexListViewModel {
        <#code#>
    }
    
}
