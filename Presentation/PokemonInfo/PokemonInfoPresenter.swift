//
//  PokemonInfoPresenter.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import UIKit
import PokedexDomain

@MainActor
public protocol PokemonInfoRouterProcotol: AnyObject {
    func assign(_ destination: PokemonInfoDestination)
}

@MainActor
public protocol PokemonInfoRendererProtocol: AnyObject {
    func render(_ viewModel: PokemonInfoViewModel)
}

public enum PokemonInfoViewModel {
    case pokemonInfo(FormattedPokemonInfo)
    case pokemonImage(UIImage)
}

public struct FormattedPokemonInfo {
    let number: AttributedString
    let name: AttributedString
    let types: [AttributedString]
    let figure: [AttributedString]
}

public enum PokemonInfoDestination {
    case dismiss
}

public final class PokemonInfoPresenter: PokemonInfoOutputPort {
    
    private let router: PokemonInfoRouterProcotol
    private let renderer: PokemonInfoRendererProtocol
    
    public init(
        router: PokemonInfoRouterProcotol,
        renderer: PokemonInfoRendererProtocol
    ) {
        self.router = router
        self.renderer = renderer
    }
    
    public func present(_ response: PokemonInfoResponse) {
        <#code#>
    }
    
}
