//
//  PokedexListController.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import PokedexDomain

public protocol PokedexInputPort {
    func loadNextPokemonIDList(offset: Int)
    func completedLoadNextPokemonIDList()
    func loadPokemonImage(_ pokemonID: PokemonID)
    func selectedPokemon(_ pokemonID: PokemonID)
    func onAppear()
}

public final class PokedexListController: PokedexInputPort {
    
    private var nextPokemonIDListIsloading: Bool = false
    private var onNextView: Bool = false
    
    private let useCase: PokedexListUseCaseProtocol
    
    public init(useCase: PokedexListUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func loadNextPokemonIDList(offset: Int) {
        
        guard !nextPokemonIDListIsloading else { return }
        nextPokemonIDListIsloading = true

        useCase.request(.fetchPokemonIDList(offset: offset))
    }
    
    public func completedLoadNextPokemonIDList() {
        nextPokemonIDListIsloading = false
    }
    
    public func loadPokemonImage(_ pokemonID: PokemonID) {
        useCase.request(.fetchPokemonImage(pokemonID))
    }
    
    public func selectedPokemon(_ pokemonID: PokemonID) {
        guard !onNextView else { return }
        useCase.request(.selectedPokemon(pokemonID))
        onNextView = true
    }
    
    public func onAppear() {
        onNextView = false
    }
}
