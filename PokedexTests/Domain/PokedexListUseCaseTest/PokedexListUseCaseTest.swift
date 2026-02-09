//
//  PokedexListUseCaseTest.swift
//  Pokedex
//
//  Created by jerry on 2/3/26.
//

import XCTest

/*
 테스트 설계
 PokedexListRequest -> PokedexListResponse
 
 1. (정상응답) fetchPokemonList -> appendPokemonIDList([PokemonID])

 2. (정상응답) fetchPokemonImage(PokemonID) -> setPokemonImage(imageData: PokemonImageData)
 - ID 일치 확인
 
 3. (정상응답) selectedPokemon(PokemonID) -> pushPokemonInfo(pokemonID: PokemonID)
 - ID 일치 확인
 
 4. (포켓몬 리스트 중복 요청 실패) fetchPokemonIDList -> handleError(.pokemonIDListIsOnloading)
 - repository fetchPokemonIDList 호출 횟수 확인
 
 5. (오프라인 실패) fetchPokemonList(PokemonID) -> handleError(.offline)
 
 6. (unknown 실패) fetchPokemonList(PokemonID) -> handleError(.unknown)
 
 7-1. (오프라인 실패) fetchPokemonImage(PokemonID) -> pokemonImageLoadFaild(PokemonID)
 7-2. (unknown 실패) fetchPokemonImage(PokemonID) -> pokemonImageLoadFaild(PokemonID)
 - ID 일치 확인
 */

final class PokedexListUseCaseTest: XCTestCase {
    
    private var sut: PokedexListUseCase!
    private var spyPresenter: SpyPokedexListPresenter!
    private var spyRepository: SpyPokedexListRepository!

    override func setUp() {
        super.setUp()
        spyPresenter = SpyPokedexListPresenter()
        spyRepository = SpyPokedexListRepository()
        sut = PokedexListUseCase(outputPort: spyPresenter, repository: spyRepository)
    }

    override func tearDown() {
        sut = nil
        spyPresenter = nil
        spyRepository = nil
        super.tearDown()
    }
}

