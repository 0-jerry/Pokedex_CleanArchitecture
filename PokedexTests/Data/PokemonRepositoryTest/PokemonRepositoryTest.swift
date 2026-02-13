//
//  PokemonRepositoryTest.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

/*
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
    
    private enum TestConstants {
        static let defaultPokemonID = 1000
        static let testPokemonIDs = [1, 100, 1000]
        static let testImageIDs = [0, 1, 2, 3, 1000]
        static let urlMappingTestIterations = 3
        static let limit = 21
    }
    
    private var sut: PokemonRepository!
    
    private var spyPokeAPIURLMapper: SpyPokeAPIURLMapper!
    private var fakeCache: FakeCache!
    private var stubNetworkStatusProvider: StubNetworkStatusProvider!
    private var stubNetworkClient: StubNetworkClient!
    private var stubPokeAPIParser: StubPokeAPIParser!
    
    override func setUp() {
        super.setUp()
        spyPokeAPIURLMapper = SpyPokeAPIURLMapper()
        fakeCache = FakeCache()
        stubNetworkStatusProvider = StubNetworkStatusProvider()
        stubNetworkClient = StubNetworkClient()
        stubPokeAPIParser = StubPokeAPIParser()
        
        sut = PokemonRepository(urlMapper: spyPokeAPIURLMapper,
                                cache: fakeCache,
                                networkStatusProvider: stubNetworkStatusProvider,
                                networkClient: stubNetworkClient,
                                parser: stubPokeAPIParser,
                                limit: TestConstants.limit)
    }
    
    override func tearDown() {
        sut = nil
        spyPokeAPIURLMapper = nil
        fakeCache = nil
        stubNetworkStatusProvider = nil
        stubNetworkClient = nil
        stubPokeAPIParser = nil
        
        super.tearDown()
    }
}

// MARK: 0. URL 매핑 테스트
// 호출 카운트, 파라미터
extension PokemonRepositoryTest {
    
    func test_URL매핑_포켓몬ID리스트_호출_실패() async {
        var expect: [PokemonIDListFetchParameter] = []
        
        for _ in 0...2 {
            let _ = try? await sut.fetchPokemonIDList()
            expect.append(PokemonIDListFetchParameter(offset: 0, limit: TestConstants.limit))
        }
        
        let result = spyPokeAPIURLMapper.fetchedPokemonListURLParameter
            .map { PokemonIDListFetchParameter(offset: $0.offset, limit: $0.limit) }
        
        XCTAssertEqual(expect, result,
                       "[fetch - fail] Pokemon list URL parameters should match expected values")
    }
    
    func test_URL매핑_포켓몬ID리스트_호출_성공() async {
        var offset = 0
        var expect: [PokemonIDListFetchParameter] = []
        
        stubNetworkClient.response[spyPokeAPIURLMapper.tempPokemonListURL] = makePokemonIDListDTO().data
        stubPokeAPIParser.tempPokemonIDList = makePokemonIDList()
        
        for _ in 0...2 {
            let _ = try? await sut.fetchPokemonIDList()
            expect.append(PokemonIDListFetchParameter(offset: offset, limit: TestConstants.limit))
            offset += TestConstants.limit
        }
        
        let result = spyPokeAPIURLMapper.fetchedPokemonListURLParameter
            .map { PokemonIDListFetchParameter(offset: $0.offset, limit: $0.limit) }
        
        XCTAssertEqual(expect, result,
                       "[fetch - success] Pokemon list URL parameters should match expected values")
    }
    
    func test_URL매핑_포켓몬_호출_성공() async {
        for pokemonID in TestConstants.testPokemonIDs {
            let _ = try? await sut.fetchPokemon(pokemonID)
        }
        XCTAssertEqual(TestConstants.testPokemonIDs, spyPokeAPIURLMapper.fetchedPokemonURLParameter,
                       "Pokemon URL parameters should match test IDs")
    }
    
    func test_URL매핑_포켓몬이미지_호출_성공() async {
        for pokemonID in TestConstants.testImageIDs {
            let _ = try? await sut.fetchPokemonImage(pokemonID)
        }
        XCTAssertEqual(TestConstants.testImageIDs, spyPokeAPIURLMapper.fetchedPokemonImageURLParameter,
                       "Pokemon image URL parameters should match test IDs")
    }
}


// MARK: 1. (성공 케이스) 캐시 히트 -> 도메인 모델 파싱
// 실행 전: 캐시 데이터 저장, 네트워크 상태 무관
// 완료 후: 캐시 데이터 호출, 캐시 히트 성공, 네트워크 클라이언트 미호출,  캐시 저장 미호출, 반환값 일치
extension PokemonRepositoryTest {
    func test_포켓몬ID리스트_캐시히트_호출_성공() async {
        // Arrange
        let url = spyPokeAPIURLMapper.tempPokemonListURL
        let pokemonIDList: [PokemonID] = makePokemonIDList()
        fakeCache.cache[url] = pokemonIDList
        stubNetworkStatusProvider.isConnected = false
        
        // Act
        let result = try? await sut.fetchPokemonIDList()
        
        // Assert
        XCTAssertEqual(result, pokemonIDList,
                       "Result should match cached pokemon ID list")
        assertCacheHit()
    }
    
    func test_포켓몬_캐시히트_호출_성공() async {
        // Arrange
        let pokemonID = TestConstants.defaultPokemonID
        let pokemonURL: URL = spyPokeAPIURLMapper.tempPokemonURL
        let pokemon: Pokemon = makePokemon(pokemonID)
        
        fakeCache.cache[pokemonURL] = pokemon
        stubNetworkStatusProvider.isConnected = false
        
        // Act
        let result = try? await sut.fetchPokemon(pokemonID)
        
        // Assert
        XCTAssertEqual(result?.id, pokemon.id,
                       "Result pokemon ID should match cached pokemon ID")
        assertCacheHit()
    }
    
    func test_포켓몬_이미지_캐시히트_호출_성공() async {
        // Arrange
        let pokemonID = TestConstants.defaultPokemonID
        let pokemonImageURL: URL = spyPokeAPIURLMapper.tempPokemonImageURL
        let pokemonImageData = makePokemonImageData(pokemonID)
        
        fakeCache.cache[pokemonImageURL] = pokemonImageData
        stubNetworkStatusProvider.isConnected = false
        
        // Act
        let result = try? await sut.fetchPokemonImage(pokemonID)
        
        // Assert
        XCTAssertEqual(result?.pokemonID, pokemonImageData.pokemonID,
                       "Result pokemon ID should match")
        XCTAssertEqual(result?.data, pokemonImageData.data,
                       "Result image data should match cached data")
        assertCacheHit()
    }
}

// MARK: 2. 캐시 없음 -> 네트워크 정상 -> API 호출 -> 도메인 모델 파싱 -> 캐시 저장 -> 도메인 모델 반환
// 실행 전: 캐시 데이터 X, 네트워크 연결됨
// 실행 후: 캐시 데이터 호출, 캐시 히트 실패, 네트워크 호출, 캐시 저장 호출, 반환값 일치
extension PokemonRepositoryTest {
    
    func test_포켓몬ID리스트_네트워크_호출_성공() async {
        // Arrange
        let url = spyPokeAPIURLMapper.tempPokemonListURL
        let model = makePokemonIDList()
        
        stubNetworkClient.response[spyPokeAPIURLMapper.tempPokemonListURL] = makePokemonIDListDTO().data
        stubPokeAPIParser.tempPokemonIDList = model

        // Act
        let result = try? await sut.fetchPokemonIDList()
        
        // Assert
        XCTAssertEqual(result, model, "Result should match expected pokemon ID list model")
        assertNetworkFetch()
        
        guard let cachedValue = fakeCache.cache[url] as? [PokemonID] else {
            XCTFail("Expected [PokemonID] in cache but got \(String(describing: type(of: fakeCache.cache[url])))")
            return
        }
        XCTAssertEqual(cachedValue, model, "Cached value should match the model")
    }
    
    func test_포켓몬_네트워크_호출_성공() async {
        // Arrange
        let pokemonID = TestConstants.defaultPokemonID
        let url = spyPokeAPIURLMapper.tempPokemonURL
        let model = makePokemon(pokemonID)
        
        stubNetworkClient.response[spyPokeAPIURLMapper.tempPokemonURL] = makePokemonDTO(pokemonID).data
        stubPokeAPIParser.tempPokemon = model
        // Act
        let result = try? await sut.fetchPokemon(pokemonID)
        
        // Assert
        XCTAssertEqual(result, model, "Result should match expected pokemon model")
        assertNetworkFetch()
        
        guard let cachedValue = fakeCache.cache[url] as? Pokemon else {
            XCTFail("Expected Pokemon in cache but got \(String(describing: type(of: fakeCache.cache[url])))")
            return
        }
        XCTAssertEqual(cachedValue, model, "Cached value should match the model")
    }
    
    func test_포켓몬_이미지_네트워크_호출_성공() async {
        // Arrange
        let pokemonID = TestConstants.defaultPokemonID
        let url = spyPokeAPIURLMapper.tempPokemonImageURL
        let model = makePokemonImageData(pokemonID)

        stubNetworkClient.response[spyPokeAPIURLMapper.tempPokemonImageURL] = makePokemonImageDataDTO(pokemonID)
        stubPokeAPIParser.tempPokemonImageData = model
        
        // Act
        let result = try? await sut.fetchPokemonImage(pokemonID)
        
        // Assert
        XCTAssertEqual(result, model, "Result should match expected pokemon image data")
        assertNetworkFetch()
        
        guard let cachedValue = fakeCache.cache[url] as? PokemonImageData else {
            XCTFail("Expected PokemonImageData in cache but got \(String(describing: type(of: fakeCache.cache[url])))")
            return
        }
        XCTAssertEqual(cachedValue, model, "Cached value should match the model")
    }
    
}

// MARK: 3. 캐시 없음 -> 네트워크 미연결 -> throw PokedexListRepositoryError.offline
// 캐시 데이터 호출, 캐시 히트 실패, 네트워크 미호출, 캐시 저장 미호출
extension PokemonRepositoryTest {
    
    func test_포켓몬ID리스트_오프라인_호출_실패() async {
        // Arrange
        stubNetworkStatusProvider.isConnected = false
        
        // Act & Assert
        do {
            let result = try await sut.fetchPokemonIDList()
            XCTFail("Expected offline error but got success with result: \(result)")
        } catch PokedexListRepositoryError.offline {
            assertOfflineState()
        } catch {
            XCTFail("Expected PokedexListRepositoryError.offline but got: \(error)")
        }
    }
    
    func test_포켓몬_오프라인_호출_실패() async {
        // Arrange
        let pokemonID = TestConstants.defaultPokemonID
        stubNetworkStatusProvider.isConnected = false
        
        // Act & Assert
        do {
            let result = try await sut.fetchPokemon(pokemonID)
            XCTFail("Expected offline error but got success with result: \(String(describing: result))")
        } catch PokedexListRepositoryError.offline {
            assertOfflineState()
        } catch {
            XCTFail("Expected PokedexListRepositoryError.offline but got: \(error)")
        }
    }
    
    func test_포켓몬_이미지_오프라인_호출_실패() async {
        // Arrange
        let pokemonID = TestConstants.defaultPokemonID
        stubNetworkStatusProvider.isConnected = false
        
        // Act & Assert
        do {
            let result = try await sut.fetchPokemonImage(pokemonID)
            XCTFail("Expected offline error but got success with result: \(String(describing: result))")
        } catch PokedexListRepositoryError.offline {
            assertOfflineState()
        } catch {
            XCTFail("Expected PokedexListRepositoryError.offline but got: \(error)")
        }
    }
}

// MARK: 4. 캐시 없음 -> 네트워크 연결 -> 부적절한 응답 -> throw Error ( != PokedexListRepositoryError.offline )
// 캐시 데이터 호출, 캐시 히트 실패, 네트워크 호출, 캐시 저장 미호출
extension PokemonRepositoryTest {
    
    func test_포켓몬ID리스트_알_수_없는_호출_실패() async {
        // Arrange
        stubNetworkClient.isEnable = false
        
        // Act & Assert
        do {
            let result = try await sut.fetchPokemonIDList()
            XCTFail("Expected network error but got success with result: \(result)")
        } catch PokedexListRepositoryError.offline {
            XCTFail("Expected network error but got offline error")
        } catch {
            // Success case - got an error that is not offline
            assertNetworkError()
        }
    }
    
    func test_포켓몬_알_수_없는_호출_실패() async {
        // Arrange
        let pokemonID = TestConstants.defaultPokemonID
        stubNetworkClient.isEnable = false
        
        // Act & Assert
        do {
            let result = try await sut.fetchPokemon(pokemonID)
            XCTFail("Expected network error but got success with result: \(String(describing: result))")
        } catch PokedexListRepositoryError.offline {
            XCTFail("Expected network error but got offline error")
        } catch {
            // Success case - got an error that is not offline
            assertNetworkError()
        }
    }
    
    func test_포켓몬_이미지_알_수_없는_호출_실패() async {
        // Arrange
        let pokemonID = TestConstants.defaultPokemonID
        stubNetworkClient.isEnable = false
        
        // Act & Assert
        do {
            let result = try await sut.fetchPokemonImage(pokemonID)
            XCTFail("Expected network error but got success with result: \(String(describing: result))")
        } catch PokedexListRepositoryError.offline {
            XCTFail("Expected network error but got offline error")
        } catch {
            // Success case - got an error that is not offline
            assertNetworkError()
        }
    }
    
}

// MARK: - Test Data Factories

private extension PokemonRepositoryTest {
    
    func makePokemonIDListDTO(offset: Int = 0, limit: Int? = nil) -> NamedAPIResourceList {
        let limit = limit ?? TestConstants.limit
        let results = (offset...offset + limit - 1).map { pokemonID in
            NamedAPIResource(name: "\(pokemonID)", url: "\(pokemonID)")
        }
        return NamedAPIResourceList(results: results)
    }
    
    func makePokemonIDList(offset: Int = 0, limit: Int? = nil) -> [PokemonID] {
        Array(offset...offset+(limit ?? TestConstants.limit)-1)
    }
    
    func makePokemonDTO(_ pokemonID: PokemonID) -> PokemonDTO {
        PokemonDTO(
            id: pokemonID,
            name: "test \(pokemonID)",
            types: [.init(slot: 1, type: NamedAPIResource(name: "bug", url: "bug"))],
            height: -1,
            weight: -1
        )
    }
    
    func makePokemon(_ pokemonID: PokemonID) -> Pokemon {
        Pokemon(
            id: pokemonID,
            name: "test \(pokemonID)",
            types: [.bug],
            height: Height(unit: .decimeter, amount: -1),
            weight: Weight(unit: .hectogram, amount: -1)
        )
    }
    
    func makePokemonImageDataDTO(_ pokemonID: PokemonID) -> Data {
        let data = pokemonID.description.data(using: .utf8)!
        return data
    }
    
    func makePokemonImageData(_ pokemonID: PokemonID) -> PokemonImageData {
        let data = pokemonID.description.data(using: .utf8)!
        return PokemonImageData(pokemonID: pokemonID, data: data)
    }
}

// MARK: - Assertion Helpers

private extension PokemonRepositoryTest {
    /// 캐시 히트 시 예상되는 상태 검증
    func assertCacheHit(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(fakeCache.valueCalledCount, 1,
                       "Cache value should be called once",
                       file: file, line: line)
        XCTAssertEqual(fakeCache.cacheHit, 1,
                       "Cache hit should occur once",
                       file: file, line: line)
        XCTAssertEqual(stubNetworkClient.callCount, 0,
                       "Network client should not be called on cache hit",
                       file: file, line: line)
        XCTAssertEqual(fakeCache.setValueCalledCount, 0,
                       "Cache setValue should not be called on cache hit",
                       file: file, line: line)
    }
    
    /// 네트워크 호출 시 예상되는 상태 검증
    func assertNetworkFetch(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(fakeCache.valueCalledCount, 1,
                       "Cache value should be called once",
                       file: file, line: line)
        XCTAssertEqual(fakeCache.cacheHit, 0,
                       "Cache should miss",
                       file: file, line: line)
        XCTAssertEqual(stubNetworkClient.callCount, 1,
                       "Network client should be called once",
                       file: file, line: line)
        XCTAssertEqual(fakeCache.setValueCalledCount, 1,
                       "Cache setValue should be called once to store result",
                       file: file, line: line)
    }
    
    /// 오프라인 상태 시 예상되는 상태 검증
    func assertOfflineState(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(fakeCache.valueCalledCount, 1,
                       "Cache value should be called once",
                       file: file, line: line)
        XCTAssertEqual(fakeCache.cacheHit, 0,
                       "Cache should miss",
                       file: file, line: line)
        XCTAssertEqual(stubNetworkClient.callCount, 0,
                       "Network client should not be called when offline",
                       file: file, line: line)
        XCTAssertEqual(fakeCache.setValueCalledCount, 0,
                       "Cache setValue should not be called when offline",
                       file: file, line: line)
    }
    
    /// 네트워크 에러 시 예상되는 상태 검증 (캐시 미스 + 네트워크 호출 + 캐시 저장 실패)
    func assertNetworkError(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(fakeCache.valueCalledCount, 1,
                       "Cache value should be called once",
                       file: file, line: line)
        XCTAssertEqual(fakeCache.cacheHit, 0,
                       "Cache should miss",
                       file: file, line: line)
        XCTAssertEqual(stubNetworkClient.callCount, 1,
                       "Network client should be called once",
                       file: file, line: line)
        XCTAssertEqual(fakeCache.setValueCalledCount, 0,
                       "Cache setValue should not be called on network error",
                       file: file, line: line)
    }
}

