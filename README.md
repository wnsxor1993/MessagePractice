# MessagePractice

**Socket 통신 시험 및 메세지 UI 구현 (with DiffableDataSource)**
<br>

## 🎯 프로젝트 목표

```
    1. SocketIO / WebSocket 중 어느 방식 구현이 나을지 통신 시험
    2. 메세지 UI 구현 연습
    3. DiffableDataSource 구현 연습
```
<br>

## 🙊 목표 선정 이유
- 본 프로젝트 작업 전, Socket 통신 방식에 대한 테스트 필요
- Socket 통신을 테스트하게 됐으니 구현해본 적 없던 채팅 UI와 함께 DiffableDataSource를 구현해보고자 함

<br>

## 📝 화면 개요
|   메인 화면    |
| :----------: |
|  <img src="https://velog.velcdn.com/images/wnsxor1993/post/c57068b0-29b2-4e57-9e8f-bfde7d2a4cf1/image.gif" width="250"> |
|   스크롤과 서브설명 셀 선택 시, 상세설명 이동    |

## ⚙️ 개발 환경


[![Swift](https://img.shields.io/badge/swift-v5.5-orange?logo=swift)](https://developer.apple.com/kr/swift/)
[![Xcode](https://img.shields.io/badge/xcode-v14.0-blue?logo=xcode)](https://developer.apple.com/kr/xcode/)
[![RxSwift](https://img.shields.io/badge/RxSwift-6.5.0-red)]()
[![Moya](https://img.shields.io/badge/Moya-15.0-red)]()
<img src="https://img.shields.io/badge/UIkit-000000?style=flat&logo=UIkit" alt="uikit" maxWidth="100%">


<br>

## 🌟 고민과 해결

### 🔅 채팅 UI
#### 1. Dynamic Height
- 고민 사항
    - CollectionView에서 가변적인 높이를 구현하고자 했으나, 채팅이 추가되자마자 반영되지 않고 한참 뒤에 높이가 변하는 문제 발생

- 해결
    - Main Run Loop의 Update Cycle의 시점이 맞지 않기 때문에 발생하는 문제로서 셀에 데이터를 주입한 직후(dequeueReusableCell 구문)에 layoutIfNeeded()를 호출하여 텍스트 높이에 맞춰 셀 높이가 맞춰지도록 구현
    - 이후 sectionReload 등 다양한 방법을 찾았고, RxDataSource를 적용하면서 해당 문제가 사라짐. (결국 제때 reload를 하지 못 한 실수에 의한 문제)
    - 블로그 정리 내용
        - https://velog.io/@wnsxor1993/UICollectionView-cell-dynamic-height-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B01CustomLayout
        - https://velog.io/@wnsxor1993/UICollectionView-cell-dynamic-height-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B02Layout-Life-Cycle

#### 2. Cell Reuse
- 고민 사항
    - 셀이 재사용되면서 기존의 높이 값을 그대로 유지. 현재 들어간 데이터의 텍스트 높이에 맞지 않는 셀 높이로 출력됨

- 해결
    - 데이터를 주입할 때, 해당 셀의 오토레이아웃의 제약조건을 remake하도록 구현했지만 별다른 효과를 보지 못 함
    - 애초에 Label의 높이로 인한 문제이니 재사용할 때, layoutIfNeeded()를 호출해주면 되지 않을까 싶어 적용하였더니 해당 문제 해결.
    (정확한 동작 원리와 문제점을 파악하지 못 함. StackOverflow 대기 중)
