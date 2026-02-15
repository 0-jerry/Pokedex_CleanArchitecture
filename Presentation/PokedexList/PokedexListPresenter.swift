//
//  PokedexListPresneter.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import Foundation
import PokedexDomain

public protocol PokedexListRenderer: AnyObject {
    func render(_ viewModel: PokedexListViewModel)
}

public enum PokedexListViewModel {
    case appendPokemonList([PokemonID])
    case setupPokemonImage(PokemonImage)
    case imageLoadFail(PokemonID)
    case showError(title: String, description: String)
}


public protocol PokedexListRouterProcotol: AnyObject {
    func assign(_ destination: PokedexListDestination)
}

public enum PokedexListDestination {
    case pushPokemonInfo(PokemonID)
}

public final class PokedexListPresenter: PokedexListOutputPort {
    
    private let router: PokedexListRouterProcotol
    private weak var renderer: (PokedexListRenderer)?
    
    public init(
        router: PokedexListRouterProcotol,
        renderer: PokedexListRenderer
    ) {
        self.router = router
        self.renderer = renderer
    }
    
    public func present(_ response: PokedexListResponse) {
        var viewModel: PokedexListViewModel? = nil
        var destination: PokedexListDestination? = nil
        
        switch response {
        case .appendPokemonIDList(let pokemonIDList):
            viewModel = .appendPokemonList(pokemonIDList)
            
        case .setPokemonImageData(imageData: let imageData):
            if let pokemonImage = PokemonImage(pokemonImageData: imageData) {
                viewModel = .setupPokemonImage(pokemonImage)
            } else {
                viewModel = .imageLoadFail(imageData.pokemonID)
            }
            
        case .pushPokemonInfo(pokemonID: let pokemonID):
            destination = .pushPokemonInfo(pokemonID)
            
        case .handleError(let error):
            switch error {
            case .offline:
                viewModel = .showError(title: "오프라인 상태",
                                       description: "네트워크 상태를 확인해주세요.")
                
            case .pokemonImageLoadFaild(let pokemonID):
                viewModel = .imageLoadFail(pokemonID)
                
            case .unknown:
                viewModel = .showError(title: "알 수 없는 에러",
                                       description: "리스트를 불러오는데 실패했습니다.")
                
            @unknown default:
                fatalError("[\(self).\(#function)] \(error) @unknown default")
            }
            
        @unknown default:
            fatalError("[\(self).\(#function)] @unknown default")
        }
        
        if let viewModel { renderer?.render(viewModel) }
        if let destination { router.assign(destination) }
    }
    
}
