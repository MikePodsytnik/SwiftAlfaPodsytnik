# Finance Tracker

# Лабораторная 2
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
    case idle
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
    case idle
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
    func didTapAddTransaction()
}
```

### Presentation <-> Application (UseCases)

``` swift
protocol CreateTransactionUseCase {
    func execute(userId: UserID, transaction: Transaction) throws
}

protocol DeleteTransactionUseCase {
    func execute(id: TransactionID) throws
}

protocol FetchTransactionsUseCase {
    func execute(userId: UserID) throws -> [Transaction]
}

protocol GetTransactionDetailsUseCase {
    func execute(id: TransactionID) throws -> Transaction
}

protocol LoginUseCase {
    func execute(email: String, password: String) throws -> UserSession
}
```

### Domain <-> Data

``` swift
protocol AuthRepository {
    func login(email: String, password: String) throws -> UserSession
}

protocol TransactionsRepository {
    func fetchTransactions(userId: UserID) throws -> [Transaction]
    func fetchTransaction(id: TransactionID) throws -> Transaction
    func createTransaction(userId: UserID, transaction: Transaction) throws
    func deleteTransaction(id: TransactionID) throws
}
```

### Router

``` swift
protocol AuthRouter {
    func openTransactionsList(session: UserSession)
}

protocol TransactionsListRouter {
    func openTransactionDetails(id: TransactionID)
    func openAddTransaction()
}

protocol TransactionDetailsRouter {
    func close()
}

protocol AddTransactionRouter {
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

# Лабораторная 3

После запуска теперь открывается экран авторизации.

Экран реализован на **UIKit** и содержит:

- поле ввода **Email**
- поле ввода **Password**
- кнопку **Login**

Для корректной работы на маленьких экранах используются `UIScrollView` и динамическое изменение `contentInset` при появлении клавиатуры

Репозиторий проверяет логин и пароль и возвращает сессию.

Данные для входа.
Email: admin@test.com
Password: 123456

При успешной авторизации выполняется переход на экран TransactionsList

# Лабораторная 4

## Используемое API

Для загрузки данных используется публичный API DummyJSON.

Endpoint:
`GET https://dummyjson.com/carts?limit=20&skip=0`

Для пагинации используются query-параметры:
- `limit` — размер страницы
- `skip` — смещение
## Формат ответа

Сервер возвращает не массив напрямую, а объект верхнего уровня, внутри которого массив лежит в поле `carts`.

Основные поля ответа:
- `carts` — массив элементов
- `total` — общее количество элементов
- `skip` — текущее смещение
- `limit` — размер страницы

Далее json маппится на DTO, а DTO маппится на доменные модели, которые уже используются в UI.

## Дополнительно реализовано

### Обработка ошибок
Используется собственный `NetworkError`, который маппится в понятные сообщения для UI.

### Отмена запроса
При повторной загрузке предыдущий `Task` отменяется.

### Пагинация
Реализована постраничная загрузка через `limit` и `skip`.

### Кэширование
Реализован in-memory cache страниц через `NSCache`.

# Лабораторная 5

Использован `UITableView`, так как требуется простой вертикальный список в одну колонку.
Он дает встроенный reuse ячеек, `dataSource/delegate` и хорошо работает с длинными списками.

Работа с таблицей вынесена в `TransactionsListManager`, чтобы `UIViewController` не содержал лишней логики.

### Состояния экрана

Экран поддерживает:

* `loading` — fullscreen индикатор
* `content` — список элементов
* `empty` — заглушка "пусто"
* `error` — сообщение об ошибке + кнопка retry

## Пагинация

Реализована через `willDisplay`:
* при достижении последних элементов списка вызывается загрузка следующей страницы
* защита от повторных запросов (`isLoading`, `hasMorePages`)
* новые элементы добавляются через `insertRows`, без `reloadData()`

Экран открывается после авторизации (логин и пароль выше в описании лабы 3).

## Как проверить состояния

* `loading` — при первом открытии
* `content` — после успешной загрузки
* `empty` — если список пуст (можно временно изменить `TransactionsRepositoryImpl` на возвращающий пустой массив)
* `error` — при ошибке загрузки (можно временно отключить интернет)

При тапе на элемент списка открывается экран деталей транзакции (заглушка).
Навигация реализована через router.

# Лабораторная 6

## Токены дизайн-системы

### Colors
- `background`
- `surface`
- `primary`
- `secondary`
- `textPrimary`
- `textSecondary`
- `textOnPrimary`
- `error`
- `success`
- `border`
- `fieldBackground`
- `divider`

Все цвета поддерживают Light/Dark режим через dynamic `UIColor`.

### Typography
- `largeTitle`
- `title`
- `headline`
- `body`
- `bodyMedium`
- `caption`
- `error`
- `button`

Реализованы через:
- `DS.Typography.font(for:)`
- `DS.Typography.color(for:)`

Также есть extension:
- `UILabel.apply(_ style: TextStyle)`

### Spacing
- `xs`
- `s`
- `m`
- `l`
- `xl`
- `xxl`

### Radius
- `s`
- `m`
- `l`

## Компоненты

Реализованы переиспользуемые UI-компоненты.

### 1. DSButton
- стили: `primary`, `secondary`, `destructive`
- состояния: `normal`, `loading`, `disabled`
- конфигурация через:
  - `configure(title:)`
  - `setState(_:)`

### 2. DSTextField
- состояния: `normal`, `focused`, `error`, `disabled`
- ошибка является частью состояния:
  - `setState(.error("message"))`

### 3. DSStateView
- состояния:
  - `loading`
  - `empty`
  - `error`
- поддерживает optional кнопку действия

### 4. InfoRowView
- отображение пары `title/value`

## Где используется

Дизайн-система применяется на экранах:
- `AuthViewController`
- `TransactionsListViewController`
- `TransactionDetailsViewController`

### AuthViewController
Используются:
- `DSButton`
- `DSTextField`
- текстовые стили DS

### TransactionsListViewController
Используются:
- `DSStateView`
- DS-ячейка списка
- токены цветов и spacing

### TransactionDetailsViewController
Используются:
- `DSStateView`
- `DSButton`
- `InfoRowView`

## Как проверить состояния

### 1. Auth экран
- `loading` — при нажатии Login
- `error` — при неверных данных

### 2. TransactionsList
- `loading` — при первой загрузке (а ещё если пытаться запустить без VPN, мой источник JSON не в белых списках :)))
- `empty` — если отключить репозиторий
- `error` — если отключить интернет

