import SwiftUI
import PokedexDomain
import PokedexData

public enum PokedexListFactory_SwiftUI {
    
    @MainActor public static func create() -> some View {
        let state = PokedexListState()
        let router = PokedexListRouter_SwiftUI()
        
        let presenter = PokedexListPresenter(
            router: router,
            renderer: state
        )
        
        let useCase = PokedexListUseCase(
            outputPort: presenter,
            repository: PokemonRepository()
        )
        
        let controller = PokedexListController(useCase: useCase)
        state.input = controller
        
        let view = PokedexListScreen(
            state: state,
            router: router,
            input: controller
        )
        
        return view
    }
}
