import SwiftUI
import PokedexDomain

struct PokemonInfoScreen: View {
    @StateObject var state: PokemonInfoState
    let router: PokemonInfoRouter_SwiftUI
    let input: PokemonInfoInputPort
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.hex(.primaryRed).ignoresSafeArea()
            
            if let pokemonDetails = state.pokemonInfo {
                ScrollView {
                    VStack(spacing: 5) {
                        Image(uiImage: pokemonDetails.image.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                        
                        Text("\(pokemonDetails.info.number) \(pokemonDetails.info.name)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                        
                        HStack(spacing: 10) {
                            ForEach(pokemonDetails.info.types, id: \.string) { type in
                                Text(type.string)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 24)
                                    .background(Color.hex(type.backgroundColor))
                                    .cornerRadius(4)
                                    .clipped()
                            }
                        }
                        .frame(height: 30)
                        
                        if let weight = pokemonDetails.info.figure.first {
                            Text(weight)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.top, 5)
                        }
                        
                        if pokemonDetails.info.figure.count > 1, let height = pokemonDetails.info.figure.last {
                            Text(height)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        Spacer(minLength: 30)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.hex(.secondaryRed))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
        .onAppear {
            input.loadPokemonInfo()
            router.onDismiss = {
                dismiss()
            }
        }
        .alert(item: $state.error) { error in
            Alert(
                title: Text(error.title),
                message: Text(error.message),
                primaryButton: .default(Text("재시도"), action: {
                    input.loadPokemonInfo()
                }),
                secondaryButton: .cancel(Text("취소"), action: {
                    input.dismiss()
                })
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .navigationTitle("")
    }
}
