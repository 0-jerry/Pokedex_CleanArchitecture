# Domain 

### Entity

 SRP:
 - 도메인 모델에 대한 로직만을 담당합니다.
 
 OCP: 
 - 외부 의존성을 전혀 갖지 않습니다.


### Use Case
 
 SRP:
 - 비즈니스 로직에서의 도메인 데이터 호출은 Repository, 비즈니스 로직 응답 출력은 Presenter에게 추상화된 형태로 의존하여,
   비즈니스 로직 처리 흐름만을 담당합니다.
 
 OCP:
 - 인터페이스 추상화를 통해 Controller에서 Use Case의 구체타입 의존성을 추상타입 의존성으로 축소합니다.
 
 DIP:
 - 처리흐름에 따라 의존성이 필요한 하위 모듈 Presenter, Repository을 Use Case모듈에서 정의해 의존성을 역전합니다.

---

# Presenter 

### Controller 

 SRP:
 - View를 하위 객체로 분리해 Controller는 분리해 입력에 대한 비즈니스 로직 요청을 담당합니다.


### Presenter 

 SRP:
 - Presenter는 PokedexListResponse -> PokedexListViewModel 로 변환하는 로직을 담당합니다.
 - Route 화면이동, Renderer 출력을 할당해 책임을 분리합니다.
 
 DIP:
 - Router, Renderer 에 대한 의존성을 역전시켜, 하위객체에 대한 의존성을 제어합니다.

---

# Data

### Repository

SRP: 
- Cache / NetworkProvider / APIClient / URLMapper / DTOParser 로 각각의 처리흐름을 추상화

OCP:
- 하위 객체에 대해 추상 타입 의존성을 통해 하위 객체에 의한 코드 오염을 방지

ISP:
- PokemonRepository: PokedexListRepository / PokemonInfoRepository 로 인터페이스 분리 
