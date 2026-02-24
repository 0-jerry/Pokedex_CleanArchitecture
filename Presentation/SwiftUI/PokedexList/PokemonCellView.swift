import SwiftUI
import PokedexDomain

struct PokemonCellView: View {
    let pokemonID: PokemonID
    let image: PokemonImage?
    let isFailed: Bool
    let input: PokedexInputPort
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.hex(.primaryWhite))
            
            if let image = image {
                Image(uiImage: image.image)
                    .resizable()
                    .scaledToFit()
                    .padding(5)
            } else if isFailed {
                Image(systemName: "photo.badge.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .padding(20)
                    .foregroundColor(.gray)
            } else {
                ProgressView()
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .onAppear {
            if image == nil && !isFailed {
                input.loadPokemonImage(pokemonID)
            }
        }
    }
}
