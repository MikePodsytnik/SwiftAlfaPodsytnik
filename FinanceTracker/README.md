# Finance Tracker

## Архитектура
В проекте используется Clean Architecture. Состоящая из слоёв: UI (UIKit), Presentation, Application (Use Cases), Domain и Data.

В первую очередь, она мне знакома по прошлым проектам. Во-вторых, зависимости в чистой архитектуре направлены внутрь, что изолирует бизнес-логику и позволяет легче расширять функционал. Разделение четкое и не смешивает ответственности. Ещё в чистой архитектуре проще контролировать, какие данные ты отдаешь наружу, что делает систему безопаснее. Тестировать решение с чистой архитектурой тоже довольно просто, так как все контракты между слоями честко прописаны.

## Модули приложения

### 1. AuthModule

Отвечает за авторизацию пользователя и создание пользовательской сессии.

- Вход: отсутствует (начальный экран приложения)

- Выход: didLogin(session: UserSession), didFail(error: AuthError)

- UI состояния:

``` swift
enum AuthViewState: Equatable {
    case initial
    case loading
    case error(String)
}
```

### Основные сценарии

#### Сценарий 1: Успешный логин

1.  Пользователь вводит email и пароль
2.  Нажимает кнопку "Войти"
3.  Отображается состояние loading
4.  UseCase выполняет авторизацию
5.  При успехе открывается экран списка операций

#### Сценарий 2: Ошибка авторизации

1.  Пользователь вводит данные
2.  Сервер возвращает ошибку
3.  Отображается состояние error


### 2. TransactionsListModule

Отвечает за отображение списка финансовых операций пользователя.

- Вход: UserSession, фильтр (например, период)

- Выход: didSelectTransaction(id: TransactionID), didTapAddTransaction
- UI состояния:

``` swift
enum TransactionsListViewState: Equatable {
    case loading
    case content([TransactionItemViewModel])
    case empty
    case error(String)
}
```

### Основные сценарии

#### Сценарий 1: Загрузка списка

1.  Экран открывается
2.  Presenter вызывает FetchTransactionsUseCase
3.  Показывается loading
4.  Отображается список операций

#### Сценарий 2: Пустой список

1.  UseCase возвращает пустой массив
2.  Отображается состояние empty

#### Сценарий 3: Переход в детали операции

1.  Пользователь нажимает на операцию
2.  Router открывает TransactionDetailsModule

### 3. TransactionDetailsModule

Отвечает за отображение детальной информации об операции.

- Вход: TransactionID, UserSession

- Выход: didDeleteTransaction, didClose

- UI состояния:

``` swift
enum TransactionDetailsViewState: Equatable {
    case loading
    case content(TransactionDetailsViewModel)
    case error(String)
}
```

### Основные сценарии

#### Сценарий 1: Загрузка деталей

1.  Экран открывается
2.  UseCase получает данные по ID
3.  Отображается content

#### Сценарий 2: Удаление операции

1.  Пользователь нажимает "Удалить"
2.  Вызывается DeleteTransactionUseCase
3.  После успеха экран закрывается

### 4. AddTransactionModule

Отвечает за создание новой финансовой операции.

- Вход: UserSession

- Выход: didCreateTransaction, didCancel

- UI состояния:

``` swift
enum AddTransactionViewState: Equatable {
    case initial
    case loading
    case validationError(String)
    case error(String)
}
```

### Основные сценарии

#### Успешное создание

1.  Пользователь вводит сумму, категорию, дату, комментарий
2.  Нажимает "Сохранить"
3.  Выполняется CreateTransactionUseCase
4.  После успеха экран закрывается

#### Ошибка валидации

1.  Пользователь вводит некорректные данные
2.  Отображается validationError


## Контракты между слоями

### View <-> Presentation

### Auth

``` swift
protocol AuthView: AnyObject {
    func render(_ state: AuthViewState)
}

protocol AuthPresenter {
    func didLoad()
    func didTapLogin(email: String, password: String)
}
```

### TransactionsList

``` swift
protocol TransactionsListView: AnyObject {
    func render(_ state: TransactionsListViewState)
}

protocol TransactionsListPresenter {
    func didLoad()
    func didSelectTransaction(id: TransactionID)
}
```

### Presentation <-> Application (UseCases)

``` swift
protocol LoginUseCase {
    func execute(email: String, password: String) async throws -> UserSession
}

protocol FetchTransactionsUseCase {
    func execute(userId: UserID) async throws -> [Transaction]
}

protocol GetTransactionDetailsUseCase {
    func execute(id: TransactionID) async throws -> Transaction
}

protocol DeleteTransactionUseCase {
    func execute(id: TransactionID) async throws
}
```

### Domain <-> Data

``` swift
protocol AuthRepository {
    func login(email: String, password: String) async throws -> UserSession
}

protocol TransactionsRepository {
    func fetchTransactions(userId: UserID) async throws -> [Transaction]
    func fetchTransaction(id: TransactionID) async throws -> Transaction
    func deleteTransaction(id: TransactionID) async throws
}
```

### Router

``` swift
protocol AuthRouter {
    func openTransactionsList(session: UserSession)
}

protocol TransactionsListRouter {
    func openTransactionDetails(id: TransactionID)
}

protocol TransactionDetailsRouter {
    func close()
}
```

## Модели данных

``` swift
struct UserSession: Equatable {
    let token: String
    let userId: UserID
}

struct Transaction: Equatable {
    let id: TransactionID
    let amount: Decimal
    let category: String
    let date: Date
    let comment: String?
}

typealias TransactionID = String
typealias UserID = String
```

## ViewModels

``` swift
struct TransactionItemViewModel: Equatable {
    let id: TransactionID
    let title: String
    let subtitle: String
    let formattedAmount: String
}

struct TransactionDetailsViewModel: Equatable {
    let title: String
    let amount: String
    let category: String
    let date: String
    let comment: String?
}
```

## Зависимости

UI → Presentation → Application → Domain → Data

-   UI ничего не знает о Data
-   Domain не зависит от UIKit
-   Data реализует только протоколы Domain
-   Навигация вынесена в Router

## Тестируемость

Каждый слой зависит только от протоколов: Presenter тестируется через
мок View и мок UseCase, UseCase тестируется через мок Repository, Data
слой можно тестировать отдельно


