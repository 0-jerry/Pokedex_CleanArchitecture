//
//  PokemonInfoController.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import PokedexDomain

public protocol PokemonInfoInputPort {
    func loadPokemonInfo()
    func completedLoad()
    func dismiss()
}

public final class PokemonInfoController: PokemonInfoInputPort {
    
    private var isLoading: Bool = false
    private let useCase: PokemonInfoUseCaseProtocol
    
    public init(useCase: PokemonInfoUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func loadPokemonInfo() {
        guard !isLoading else { return }
        useCase.request(.loadPokemonInfo)
        isLoading = true
    }
    
    public func completedLoad() {
        isLoading = false
    }
    
    public func dismiss() {
        useCase.request(.dismiss)
    }
    
}
