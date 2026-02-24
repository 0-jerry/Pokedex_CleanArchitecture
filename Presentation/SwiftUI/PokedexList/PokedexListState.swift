import SwiftUI
import Combine
import PokedexDomain

@MainActor
final class PokedexListState: ObservableObject, PokedexListRenderer {
    @Published var pokemonIDs: [PokemonID] = []
    @Published var pokemonImages: [PokemonID: PokemonImage] = [:]
    @Published var imageLoadFailIDs = Set<PokemonID>()
    @Published var error: ViewError?

    var input: PokedexInputPort?

    func render(_ viewModel: PokedexListViewModel) {
        switch viewModel {
        case .appendPokemonList(let newPokemonIDList):
            let existingIDs = Set(pokemonIDs)
            let trulyNewIDs = newPokemonIDList.filter { !existingIDs.contains($0) }
            if !trulyNewIDs.isEmpty {
                pokemonIDs.append(contentsOf: trulyNewIDs)
            }
            input?.completedLoadNextPokemonIDList()
            
        case .setupPokemonImage(let pokemonImage):
            pokemonImages[pokemonImage.pokemonID] = pokemonImage
            imageLoadFailIDs.remove(pokemonImage.pokemonID)
            
        case .imageLoadFail(let pokemonID):
            imageLoadFailIDs.insert(pokemonID)
            
        case .showError(let title, let description):
            self.error = ViewError(title: title, description: description)
            input?.completedLoadNextPokemonIDList()
        }
    }
    
    struct ViewError: Identifiable {
        var id: String { title + description }
        let title: String
        let description: String
    }
}

@MainActor
final class PokedexListRouter_SwiftUI: PokedexListRouterProcotol, ObservableObject {
    
    @Published var navigationPath = NavigationPath()

    func assign(_ destination: PokedexListDestination) {
        switch destination {
        case .pushPokemonInfo(let pokemonID):
            navigationPath.append(pokemonID)
        }
    }
}
