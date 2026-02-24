import SwiftUI
import PokedexDomain
import PokedexData

public enum PokemonInfoFactory_SwiftUI {
    
    @MainActor public static func create(pokemonID: PokemonID) -> some View {
        let state = PokemonInfoState()
        let router = PokemonInfoRouter_SwiftUI()
        
        let presenter = PokemonInfoPresenter(
            router: router,
            renderer: state
        )
        
        let useCase = PokemonInfoUseCase(
            pokemonID: pokemonID,
            output: presenter,
            repository: PokemonRepository()
        )
        
        let controller = PokemonInfoController(useCase: useCase)
        state.input = controller
        
        return PokemonInfoScreen(
            state: state,
            router: router,
            input: controller
        )
    }
}
