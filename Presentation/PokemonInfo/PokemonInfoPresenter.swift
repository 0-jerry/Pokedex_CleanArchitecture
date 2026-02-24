//
//  PokemonInfoPresenter.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import Foundation
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
    case pokemonInfo(info: FormattedPokemonInfo, image: PokemonImage)
    case showErrorAlert(title: String, message: String)
}

public struct FormattedPokemonInfo {
    let number: String
    let name: String
    let types: [FormattedPokemonType]
    let figure: [String]
}

public struct FormattedPokemonType {
    let string: String
    let backgroundColor: HEX
}

public enum PokemonInfoDestination {
    case dismiss
}

public final class PokemonInfoPresenter: PokemonInfoOutputPort {
    
    private let router: PokemonInfoRouterProcotol
    private weak var renderer: (PokemonInfoRendererProtocol)?
    
    public init(
        router: PokemonInfoRouterProcotol,
        renderer: PokemonInfoRendererProtocol
    ) {
        self.router = router
        self.renderer = renderer
    }
    
    public func present(_ response: PokemonInfoResponse) {
        var viewModel: PokemonInfoViewModel?
        var destination: PokemonInfoDestination?
        
        switch response {
            
        case .pokemonInfo(pokemon: let pokemon,
                          pokemonImageData: let pokemonImageData):
            guard let pokemonImage = PokemonImage(pokemonImageData: pokemonImageData) else {
                viewModel = .showErrorAlert(title: "알 수 없는 에러",
                                            message: "알 수 없는 에러가 발생했습니다.\n다시 시도하시겠습니까?")
                break
            }
            viewModel = .pokemonInfo(info: formatedInfo(from: pokemon),
                                     image: pokemonImage)
            
        case .dismiss:
            destination = .dismiss
            
        case .error(let error):
            switch error {
            case .offline:
                viewModel = .showErrorAlert(title: "오프라인 상태",
                                            message: "네트워크 상태를 확인해주세요.")
            case .unknown:
                viewModel = .showErrorAlert(title: "알 수 없는 에러",
                                            message: "알 수 없는 에러가 발생했습니다.\n다시 시도하시겠습니까?")
            @unknown default:
                break
            }
        @unknown default:
            break
        }
        
        Task { [weak renderer] in
            if let renderer, let viewModel {
                await renderer.render(viewModel)
            }
        }
        
        Task { [weak router] in
            if let router, let destination {
                await router.assign(destination)
            }
        }
    }
    
    
    private func formatedInfo(from pokemon: Pokemon) -> FormattedPokemonInfo {
        let weight = pokemon.weight
        let killogram =  (Double(weight.amount) / 10).description + "kg"
        let height = pokemon.height
        let meter = (Double(height.amount) / 10).description + "m"
        
        return .init(
            number: "No.\(pokemon.id)",
            name: PokemonTranslator.koreanName(for: pokemon.name),
            types: pokemon.types.map { PokemonTypeTranslator.translate($0) },
            figure: ["몸무게: \(killogram)", "키: \(meter)"]
        )
    }
}
