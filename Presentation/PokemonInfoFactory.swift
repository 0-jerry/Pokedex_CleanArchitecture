//
//  PokemonInfoFactory.swift
//  Pokedex
//
//  Created by jerry on 2/24/26.
//

import UIKit
import PokedexDomain
import PokedexData

public enum PokemonInfoFactory {
    
    /// `PokemonInfo` 화면을 구성하고 의존성이 주입된 ViewController를 반환합니다.
    /// - Parameters:
    ///   - navigationController: 화면 전환을 담당할 NavigationController (Router에 주입)
    ///   - pokemonID: 상세 정보를 조회할 포켓몬의 식별자 (UseCase에 주입)
    /// - Returns: 조립이 완료된 `PokemonInfoViewController`
    @MainActor public static func pokemonInfo(
        _ navigationController: UINavigationController,
        pokemonID: PokemonID
    ) -> PokemonInfoView {
        
        let view = PokemonInfoView()
        
        let router = PokemonInfoRouter(navigationController: navigationController)
        
        let presenter = PokemonInfoPresenter(router: router,
                                             renderer: view)
        
        // PokedexListFactory와 동일하게 PokedexData 모듈의 PokemonRepository를 사용합니다.
        // PokemonRepository는 PokemonInfoRepositoryProtocol을 채택하고 있어야 합니다.
        let useCase = PokemonInfoUseCase(pokemonID: pokemonID,
                                         output: presenter,
                                         repository: PokemonRepository())
        
        let controller = PokemonInfoController(useCase: useCase)
        view.input = controller
        return view
    }
}
