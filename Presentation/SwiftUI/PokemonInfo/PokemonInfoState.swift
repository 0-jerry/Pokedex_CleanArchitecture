import SwiftUI
import PokedexDomain
import Combine
@MainActor
final class PokemonInfoState: ObservableObject, PokemonInfoRendererProtocol {
    @Published var pokemonInfo: (info: FormattedPokemonInfo, image: PokemonImage)?
    @Published var error: ViewError?

    var input: PokemonInfoInputPort?

    func render(_ viewModel: PokemonInfoViewModel) {
        switch viewModel {
        case .pokemonInfo(let info, let image):
            self.pokemonInfo = (info, image)
        case .showErrorAlert(let title, let message):
            self.error = ViewError(title: title, message: message)
        }
        input?.completedLoad()
    }
    
    struct ViewError: Identifiable {
        var id: String { title + message }
        let title: String
        let message: String
    }
}

@MainActor
final class PokemonInfoRouter_SwiftUI: PokemonInfoRouterProcotol {
    var onDismiss: (() -> Void)?
    
    func assign(_ destination: PokemonInfoDestination) {
        switch destination {
        case .dismiss:
            onDismiss?()
        }
    }
}
