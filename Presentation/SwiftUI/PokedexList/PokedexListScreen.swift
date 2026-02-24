import SwiftUI
import PokedexDomain

struct PokedexListScreen: View {
    @StateObject var state: PokedexListState
    @StateObject var router: PokedexListRouter_SwiftUI
    let input: PokedexInputPort
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            ZStack {
                Color.hex(.primaryRed).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Image("PokeBall")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .padding(.top, 20)
                    
                    if state.pokemonIDs.isEmpty && state.error != nil {
                        ErrorPlaceholderView(
                            title: state.error?.title ?? "Error",
                            description: state.error?.description ?? "An unknown error occurred.",
                            retryAction: {
                                state.error = nil
                                input.loadNextPokemonIDList(offset: state.pokemonIDs.count)
                            }
                        )
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(state.pokemonIDs, id: \.self) { pokemonID in
                                    NavigationLink(value: pokemonID) {
                                        PokemonCellView(
                                            pokemonID: pokemonID,
                                            image: state.pokemonImages[pokemonID],
                                            isFailed: state.imageLoadFailIDs.contains(pokemonID),
                                            input: input
                                        )
                                    }
                                    .simultaneousGesture(TapGesture().onEnded {
                                        input.selectedPokemon(pokemonID)
                                    })
                                }
                            }
                            .padding(5)
                            
                            if !state.pokemonIDs.isEmpty {
                                ProgressView()
                                    .padding()
                                    .onAppear {
                                        loadNextPage()
                                    }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Pokedex")
            .navigationBarHidden(true)
            .navigationDestination(for: PokemonID.self) { pokemonID in
                PokemonInfoFactory_SwiftUI.create(pokemonID: pokemonID)
                    .onAppear {
                        input.onAppear()
                    }
            }
            .alert(item: $state.error) { viewError in
                 Alert(
                     title: Text(viewError.title),
                     message: Text(viewError.description),
                     dismissButton: .default(Text("재시도"), action: {
                        state.error = nil
                        loadNextPage()
                     })
                 )
            }
        }
        .onAppear {
            if state.pokemonIDs.isEmpty {
                loadNextPage()
            }
        }
    }
    
    private func loadNextPage() {
        guard state.canLoadNextPage else { return }
        state.canLoadNextPage = false
        input.loadNextPokemonIDList(offset: state.pokemonIDs.count)
    }
}
