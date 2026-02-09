//
//  SpyPokedexListPresenter.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

final class SpyPokedexListPresenter: PokedexListOutputPort {
    
    private(set) var responses: [PokedexListResponse] = []
    
    func present(_ response: PokedexListResponse) {
        responses.append(response)
    }
    
}
