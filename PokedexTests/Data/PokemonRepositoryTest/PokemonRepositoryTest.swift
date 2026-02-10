//
//  PokemonRepositoryTest.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

/*
 DI
 
 호출 순서
 
 1. PokeAPIURLMapper - URL 매핑, 메서드 정상 호출 테스트
 2. Cache - 캐시 히트 ( + early return 테스트)
 3. NetworkStatusProvider - 네트워크 상태에 따라 패스/Error (이미지의 경우 Unknown 에러)
 4. NetworkClient - URL -> DTO (PokemonIDList: NamedAPIResourceList / 이미지 : Data / Pokemon: PokemonDTO)
 5. PokeDTOParser - NamedAPIResourceList -> [PokemonID] / PokemonDTO -> Pokemon
 
 fetchPokemonIDList
 fetchPokemon
 fetchPokemonImage
 
 1. URL 매핑 테스트
 fetchPokemonIDList / fetchPokemon / fetchPokemonImage -> 호출 카운트 및 파라미터 확인
 
 2. 캐시
 캐시 히트 -> (Early return) NetworkClient -> callCount == 0 /
 캐시 호출 & 히트 실패 ->  NetworkClient -> callCount == 1 /
 캐시 저장 호출 -> NetworkClient callCount == 1 , NetworkClient 반환 데이터 캐싱 setValueCalledCount == 1, cache 데이터 검증
 
3. 네트워크 상태
(네트워크 미연결) 캐시 호출 == 1 , 캐시히트 == 0, NetworkClient callCount == 0, 반환 throw PokedexListRepositoryError.offline
(네트워크 연결) 캐시호출 == 1, 캐시 히트 == 0, NetworkClient callCount == 1, 캐시저장 호출 == 1, 반환값 검증
 
 
 성공
 1. 캐시 히트 -> 도메인 모델 반환
 Pokemon ID List
 Pokemon
 Pokemon Image
 
 2. 캐시 없음 -> 네트워크 정상 -> API 호출 -> 캐시 저장 -> 도메인 모델 파싱
 Pokemon ID List
 Pokemon
 Pokemon Image
 
 실패
 1. 캐시 없음 -> 네트워크 미연결 -> throw PokedexListRepositoryError.offline
 Pokemon ID List
 Pokemon
 Pokemon Image
 
 2. 캐시 없음 -> 네트워크 연결 -> 부적절한 응답 -> throw Error (.unknown)
 Pokemon ID List
 Pokemon
 Pokemon Image
 
*/

import XCTest

final class PokemonRepositoryTest: XCTestCase {
    private let limit = 21
    private var sut: PokemonRepository!
    private var spyPokeAPIURLMapper: SpyPokeAPIURLMapper!
    private var fakeCache: FakeCache!
    private var stubNetworkStatusProvider: StubNetworkStatusProvider!
    private var stubNetworkClient: StubNetworkClient!
    private var stubPokeDTOParser: StubPokeDTOParser!
    
    override func setUp() {
        super.setUp()
        spyPokeAPIURLMapper = SpyPokeAPIURLMapper()
        fakeCache = FakeCache()
        stubNetworkStatusProvider = StubNetworkStatusProvider()
        stubNetworkClient = StubNetworkClient()
        stubPokeDTOParser = StubPokeDTOParser()
        
        sut = PokemonRepository(urlMapper: spyPokeAPIURLMapper,
                                networkStatusProvider: stubNetworkStatusProvider,
                                networkClient: stubNetworkClient,
                                parser: stubPokeDTOParser,
                                cache: fakeCache,
                                limit: limit)
    }
    
    override func tearDown() {
        sut = nil
        spyPokeAPIURLMapper = nil
        fakeCache = nil
        stubNetworkStatusProvider = nil
        stubNetworkClient = nil
        stubPokeDTOParser = nil
        
        super.tearDown()
    }
}
