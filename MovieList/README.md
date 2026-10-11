# MovieList

## Предметна область

MovieList — застосунок для ведення власного списку фільмів. Користувач може додавати фільми до колекції, переглядати інформацію про них та відмічати переглянуті фільми.

## Користувач

Користувачем застосунку є людина, яка хоче зберігати та впорядковувати список фільмів для перегляду.

## Основні сценарії

- додавання нового фільму до колекції;
- перегляд списку доданих фільмів;
- позначення фільму як переглянутого;
- отримання списку непроглянутих фільмів;
- додавання та перегляд нотаток до фільмів.

## Основні сутності

### Movie

Представляє окремий фільм та містить інформацію про його назву, рік випуску, жанр, статус перегляду та нотатку.

### MovieCollection

Представляє колекцію фільмів та забезпечує роботу зі списком: додавання фільмів, пошук, зміну статусу перегляду та отримання потрібних фільмів.
# Practical Work 2

## Обрана архітектура

Для проєкту MovieList обрано архітектуру **MVVM (Model-View-ViewModel)**.

MVVM підходить для цього проєкту, оскільки дозволяє чітко розділити:

- **Model** — дані предметної області;
- **View** — відображення інтерфейсу;
- **ViewModel** — логіку представлення та взаємодію з даними.

Такий підхід зменшує зв’язність компонентів, спрощує тестування та дозволяє змінювати реалізацію джерела даних без переписування UI.

## Схема взаємодії компонентів

```text
ContentView
    ↓
MovieListViewModel
    ↓
MovieRepositoryProtocol
    ↓
MovieCollectionAdapter
    ↓
MovieCollection
```

Додатково `MovieListViewModel` використовує окрему стратегію сортування:

```text
MovieListViewModel
    ↓
MovieSortingStrategy
    ├── SortByTitleStrategy
    ├── SortByRatingStrategy
    └── SortByYearStrategy
```

## Розподіл відповідальності

- `Movie.swift` — модель одного фільму.
- `ContentView.swift` — представлення даних користувачу.
- `MovieListViewModel.swift` — логіка представлення та взаємодія з репозиторієм.
- `MovieRepositoryProtocol.swift` — абстракція доступу до даних.
- `MovieCollection.swift` — базова реалізація зберігання колекції.
- `MovieCollectionAdapter.swift` — адаптація `MovieCollection` до нового інтерфейсу репозиторію.
- `MockMovieRepository.swift` — тестова реалізація джерела даних.
- `MovieBuilder.swift` — побудова об’єктів `Movie`.
- `MovieSortingStrategy.swift` — різні способи сортування фільмів.

## Використані патерни проєктування

| Категорія | Патерн | Компонент | Призначення |
| --- | --- | --- | --- |
| Породжувальний | Builder | `MovieBuilder` | Поетапне та читабельне створення об’єктів `Movie` |
| Структурний | Adapter | `MovieCollectionAdapter` | Адаптація `MovieCollection` до `MovieRepositoryProtocol` |
| Поведінковий | Strategy | `MovieSortingStrategy` | Можливість змінювати алгоритм сортування без зміни ViewModel |

### Builder

Патерн **Builder** використовується для зручного створення об’єктів `Movie`.

Приклад:

```swift
let movie = MovieBuilder()
    .setTitle("Interstellar")
    .setYear(2014)
    .setGenre(.sciFi)
    .setRating(8.7)
    .build()
```

Завдяки цьому створення об’єкта стає більш читабельним і не потребує використання довгого конструктора.

### Adapter

`MovieCollectionAdapter` реалізує `MovieRepositoryProtocol` та використовує всередині існуючий `MovieCollection`.

Це дозволило не переписувати код першої практичної роботи, а підключити старий компонент до нової архітектури.

### Strategy

Патерн **Strategy** використовується для зміни способу сортування фільмів.

Реалізовані стратегії:

- сортування за назвою;
- сортування за рейтингом;
- сортування за роком.

Під час виконання програми стратегія може змінюватися без зміни `MovieListViewModel`.

## SOLID

### S — Single Responsibility Principle

Кожен компонент має одну основну відповідальність:

- `Movie` зберігає дані фільму;
- `MovieCollection` працює з колекцією;
- `MovieListViewModel` містить логіку представлення;
- `ContentView` відповідає за UI;
- `MovieBuilder` створює об’єкти `Movie`;
- `MovieSortingStrategy` відповідає за алгоритм сортування.

Таким чином, великий клас із надмірною кількістю обов’язків не створюється.

### O — Open/Closed Principle

Система відкрита для розширення, але закрита для зміни існуючого коду.

Наприклад, для додавання нового способу сортування достатньо створити новий клас, який реалізує `MovieSortingStrategy`. При цьому змінювати `MovieListViewModel` не потрібно.

### L — Liskov Substitution Principle

Будь-яку реалізацію `MovieRepositoryProtocol` можна використати там, де очікується цей протокол.

Наприклад:

- `MovieCollectionAdapter`;
- `MockMovieRepository`.

`MovieListViewModel` працює однаково з обома реалізаціями.

### I — Interface Segregation Principle

`MovieRepositoryProtocol` містить тільки ті методи, які потрібні ViewModel:

- отримання фільмів;
- додавання фільму;
- зміна стану перегляду.

Компоненти не змушені реалізовувати зайві методи.

### D — Dependency Inversion Principle

`MovieListViewModel` залежить не від конкретного класу `MovieCollection`, а від абстракції `MovieRepositoryProtocol`.

Це дозволяє легко замінити реальну реалізацію репозиторію на тестову.

## Dependency Injection

Залежності передаються в `MovieListViewModel` через ініціалізатор:

```swift
MovieListViewModel(
    repository: adapter,
    sortingStrategy: SortByTitleStrategy()
)
```

Для тестування можна передати:

```swift
MovieListViewModel(
    repository: MockMovieRepository(),
    sortingStrategy: SortByTitleStrategy()
)
```

При цьому код `MovieListViewModel` не змінюється.

## Перевірка заміни залежності

У проєкті реалізовано `MockMovieRepository`, який також відповідає протоколу `MovieRepositoryProtocol`.

Під час перевірки основний `MovieCollectionAdapter` був замінений на `MockMovieRepository`, після чого сценарій продовжив працювати без змін у `MovieListViewModel`.

Це демонструє використання **Dependency Injection** та **Dependency Inversion**.

## Перевірка на антипатерни

У проєкті було перевірено такі можливі проблеми:

- надмірна відповідальність одного класу;
- дублювання логіки;
- приховані глобальні залежності;
- пряме поєднання UI з доступом до даних.

У результаті:

- UI не працює напряму з `MovieCollection`;
- View використовує `MovieListViewModel`;
- ViewModel залежить від абстракції `MovieRepositoryProtocol`;
- залежності передаються через ініціалізатор;
- логіка створення та сортування винесена в окремі компоненти.

Таким чином вдалося уникнути **God Object**, жорсткої зв’язності та прихованих залежностей.

## Перевірка сценарію

1. Запустити проєкт у Xcode.
2. Обрати iPhone Simulator.
3. Натиснути Run.
4. Відкрити консоль Xcode.
5. Перевірити:
   - створення фільмів через Builder;
   - додавання фільмів через ViewModel;
   - сортування за назвою;
   - зміну Strategy;
   - сортування за рейтингом;
   - зміну стану фільму;
   - роботу через `MockMovieRepository`.

## Результат

Один завершений сценарій працює через компоненти архітектури MVVM.

У проєкті реалізовано:

- архітектурне розділення;
- Builder;
- Adapter;
- Strategy;
- принципи SOLID;
- Dependency Injection;
- Dependency Inversion;
- `MockMovieRepository` для тестування;
- перевірку на антипатерни.
