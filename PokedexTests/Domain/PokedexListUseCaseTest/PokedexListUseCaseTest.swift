//
//  PokedexListUseCaseTest.swift
//  Pokedex
//
//  Created by jerry on 2/3/26.
//

import XCTest


// 테스트 설계
// PokedexListRequest -> PokedexListResponse
// 1. (정상응답) fetchPokemonList -> appendPokemonIDList([PokemonID])
//  2. (포켓몬 리스트 중복 요청 실패) fetchPokemonIDList -> handleError(.pokemonIDListIsOnloading)
//    - repository fetchPokemonIDList 호출 횟수 확인

//  3. (오프라인 실패) fetchPokemonList(PokemonID) -> handleError(.offline)

//  4. (unknown 실패) fetchPokemonList(PokemonID) -> handleError(.unknown)

//  5. (정상응답) fetchPokemonImage(PokemonID) -> setPokemonImage(imageData: PokemonImageData)
//  - ID 일치 확인

//  6-1. (오프라인 실패) fetchPokemonImage(PokemonID) -> pokemonImageLoadFaild(PokemonID)
//  - ID 일치 확인

//  6-2. (unknown 실패) fetchPokemonImage(PokemonID) -> pokemonImageLoadFaild(PokemonID)
//  - ID 일치 확인

//  7. (정상응답) selectedPokemon(PokemonID) -> pushPokemonInfo(pokemonID: PokemonID)
//  - ID 일치 확인
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
//  1. (정상응답) fetchPokemonList -> appendPokemonIDList([PokemonID])
    func test_포켓몬ID리스트_정상응답() async {
        let request = PokedexListRequest.fetchPokemonIDList
        let expectPokemonIDList = spyRepository.pokemonIDList

        sut.request(request)
        await waitForPresenterCall(1)

        let responses = spyPresenter.responses
        XCTAssert(responses.count == 1)
        
        switch responses[0] {
        case .appendPokemonIDList(let pokemonIDLists):
            XCTAssert(pokemonIDLists == expectPokemonIDList)
            XCTAssert(spyRepository.fetchPokemonIDListCallCount == 1)
        default:
            XCTFail()
        }
    }
    
//  2. (포켓몬 리스트 중복 요청 실패) fetchPokemonIDList -> handleError(.pokemonIDListIsOnloading)
//    - repository fetchPokemonIDList 호출 횟수 확인
    func test_포켓몬ID리스트_중복요청_실패() async {
        let request = PokedexListRequest.fetchPokemonIDList
        spyRepository.isAsync = true
        
        sut.request(request)
        sut.request(request)
        await waitForPresenterCall(2)
        
        let responses = spyPresenter.responses
        XCTAssert(responses.count == 2)
        
        switch responses[0] {
        case .handleError(let error):
            XCTAssert(spyRepository.fetchPokemonIDListCallCount == 1)
            XCTAssert(error == .pokemonIDListIsOnloading)
        default:
            XCTFail()
        }
    }
//  3. (오프라인 실패) fetchPokemonList(PokemonID) -> handleError(.offline)
    func test_포켓몬ID리스트_오프라인_실패() async {
        let request = PokedexListRequest.fetchPokemonIDList
        
        spyRepository.isOffline = true
        
        sut.request(request)
        
        await waitForPresenterCall(1)
        
        let responses = spyPresenter.responses
        XCTAssert(responses.count == 1)
        
        switch responses[0] {
        case .handleError(let error):
            XCTAssert(error == .offline)
        default:
            XCTFail()
        }
    }
    
//  4. (unknown 실패) fetchPokemonList(PokemonID) -> handleError(.unknown)
    func test_포켓몬ID리스트_알_수_없는_실패() async {
        let request = PokedexListRequest.fetchPokemonIDList

        spyRepository.isUnknown = true
        
        sut.request(request)
        await waitForPresenterCall(1)

        let responses = spyPresenter.responses
        XCTAssert(responses.count == 1)
        
        switch responses[0] {
        case .handleError(let error):
            XCTAssert(error == .unknown)
        default:
            XCTFail()
        }
    }

//  5. (정상응답) fetchPokemonImage(PokemonID) -> setPokemonImage(imageData: PokemonImageData)
//  - ID 일치 확인
    func test_포켓몬이미지_정상응답() async {
        let pokemonID = 10
        let rawData = Data()
        let request = PokedexListRequest.fetchPokemonImage(pokemonID)
        spyRepository.pokemonImageRawData = rawData
        
        sut.request(request)
        
        await waitForPresenterCall(1)
        let responses = spyPresenter.responses
        XCTAssert(responses.count == 1)
        
        switch responses[0] {
        case .setPokemonImage(imageData: let imageData):
            XCTAssert(pokemonID == imageData.pokemonID)
            XCTAssert(rawData == imageData.data)
        default:
            XCTFail()
        }
    }

//  6-1. (오프라인 실패) fetchPokemonImage(PokemonID) -> pokemonImageLoadFaild(PokemonID)
//  - ID 일치 확인
    func test_포켓몬이미지_오프라인_실패() async {
        let pokemonID = 10
        let request = PokedexListRequest.fetchPokemonImage(pokemonID)
        
        spyRepository.isOffline = true
        
        sut.request(request)
        
        await waitForPresenterCall(1)
        let responses = spyPresenter.responses
        
        XCTAssert(responses.count == 1)
        
        switch responses[0] {
        case .handleError(let error):
            switch error {
            case .pokemonImageLoadFaild(let faildPokemonID):
                XCTAssert(pokemonID == faildPokemonID)
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

//  6-2. (unknown 실패) fetchPokemonImage(PokemonID) -> pokemonImageLoadFaild(PokemonID)
//  - ID 일치 확인
    func test_포켓몬이미지_알_수_없는_실패() async {
        let pokemonID = 10
        let request = PokedexListRequest.fetchPokemonImage(pokemonID)
        
        spyRepository.isUnknown = true
        
        sut.request(request)
        
        await waitForPresenterCall(1)
        let responses = spyPresenter.responses
        
        XCTAssert(responses.count == 1)
        
        switch responses[0] {
        case .handleError(let error):
            switch error {
            case .pokemonImageLoadFaild(let faildPokemonID):
                XCTAssert(pokemonID == faildPokemonID)
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }


//  7. (정상응답) selectedPokemon(PokemonID) -> pushPokemonInfo(pokemonID: PokemonID)
//  - ID 일치 확인
    func test_포켓몬선택_정상응답() async {
        let pokemonID: Int = 10
        let request = PokedexListRequest.selectedPokemon(pokemonID)
        
        sut.request(request)
        
        await waitForPresenterCall(1)
        let responses = spyPresenter.responses
        
        XCTAssert(responses.count == 1)
        
        switch responses[0] {
        case .pushPokemonInfo(pokemonID: let responsedPokemonID):
            XCTAssert(pokemonID == responsedPokemonID)
        default:
            XCTFail()
        }
    }
    
    private func waitForPresenterCall(_ count: Int) async {
        while spyPresenter.responses.count < count {
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
    }
    
}

extension PokedexListUseCaseError: Equatable {
    public static func == (lhs: PokedexListUseCaseError, rhs: PokedexListUseCaseError) -> Bool {
        switch (lhs, rhs) {
        case (.pokemonIDListIsOnloading, .pokemonIDListIsOnloading),
             (.offline, .offline),
             (.unknown, .unknown):
            return true
        case (.pokemonImageLoadFaild(let lhsID), .pokemonImageLoadFaild(let rhsID)):
            return (lhsID == rhsID)
        default:
            return false
        }
    }
}
