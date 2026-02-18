import Foundation


enum Genre: String, CaseIterable, Codable {
    case fiction, nonFiction, mystery, sciFi, biography, fantasy
}

struct Book: Identifiable, Codable, Equatable {
    let id: String
    var title: String
    var author: String
    var publicationYear: Int?
    var genre: Genre
    var tags: [String]
}

enum SearchQuery {
    case title(String)
    case author(String)
    case genre(Genre)
    case tag(String)
    case year(Int)
}

enum LibraryError: Error, LocalizedError {
    case emptyTitle
    case emptyAuthor
    case invalidYear(Int)
    case notFound(id: String)
    case duplicateId(String)
    case invalidCommand(String)
    case invalidGenre(String)
    case invalidId
    case invalidSearchField(String)
    case invalidSearchValue
    case invalidTags

    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Название не может быть пустым."
        case .emptyAuthor:
            return "Автор не может быть пустым."
        case .invalidYear(let y):
            return "Некорректный год: \(y)."
        case .notFound(let id):
            return "Книга с id \(id) не найдена."
        case .duplicateId(let id):
            return "Книга с id \(id) уже существует."
        case .invalidCommand(let s):
            return "Неизвестная команда: \(s). Введите 'help' для списка команд."
        case .invalidGenre(let s):
            return "Некорректный жанр: \(s). Доступно: \(Genre.allCases.map { $0.rawValue }.joined(separator: ", "))."
        case .invalidId:
            return "Некорректный id."
        case .invalidSearchField(let s):
            return "Некорректный критерий поиска: \(s). Доступно: title, author, genre, tag, year."
        case .invalidSearchValue:
            return "Некорректное значение для поиска."
        case .invalidTags:
            return "Некорректные теги."
        }
    }
}

protocol BookShelfProtocol {
    func add(_ book: Book) throws
    func delete(id: String) throws
    func list() -> [Book]
    func search(_ query: SearchQuery) -> [Book]
}

class BookShelf: BookShelfProtocol {
    private var booksById: [String: Book] = [:]

    func add(_ book: Book) throws {
        let normalized = try validateAndNormalize(book)
        if booksById[normalized.id] != nil {
            throw LibraryError.duplicateId(normalized.id)
        }
        booksById[normalized.id] = normalized
    }

    func delete(id: String) throws {
        let id = id.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !id.isEmpty else { throw LibraryError.invalidId }
        guard booksById.removeValue(forKey: id) != nil else {
            throw LibraryError.notFound(id: id)
        }
    }

    func list() -> [Book] {
        booksById.values.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }

    func search(_ query: SearchQuery) -> [Book] {
        let all = Array(booksById.values)

        func containsCI(_ haystack: String, _ needle: String) -> Bool {
            haystack.range(of: needle, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }

        let result = all.filter { book in
            switch query {
            case .title(let q):
                let q = q.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !q.isEmpty else { return false }
                return containsCI(book.title, q)
            case .author(let q):
                let q = q.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !q.isEmpty else { return false }
                return containsCI(book.author, q)
            case .genre(let g):
                return book.genre == g
            case .tag(let q):
                let q = q.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !q.isEmpty else { return false }
                return book.tags.contains { containsCI($0, q) }
            case .year(let y):
                return book.publicationYear == y
            }
        }

        return result.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }

    private func validateAndNormalize(_ book: Book) throws -> Book {
        var b = book

        b.title = b.title.trimmingCharacters(in: .whitespacesAndNewlines)
        b.author = b.author.trimmingCharacters(in: .whitespacesAndNewlines)

        if b.title.isEmpty { throw LibraryError.emptyTitle }
        if b.author.isEmpty { throw LibraryError.emptyAuthor }

        if let y = b.publicationYear {
            let currentYear = Calendar.current.component(.year, from: Date())
            if y < 1400 || y > currentYear {
                throw LibraryError.invalidYear(y)
            }
        }

        b.tags = normalizeTags(b.tags)
        return b
    }

    private func normalizeTags(_ tags: [String]) -> [String] {
        let cleaned = tags
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }

        var seen = Set<String>()
        var out: [String] = []
        out.reserveCapacity(cleaned.count)

        for t in cleaned where !seen.contains(t) {
            seen.insert(t)
            out.append(t)
        }
        return out
    }
}


class CommandContext {
    let shelf: BookShelfProtocol
    var shouldExit: Bool = false

    init(shelf: BookShelfProtocol) {
        self.shelf = shelf
    }
}


protocol CommandHandler: AnyObject {
    var next: CommandHandler? { get set }
    func handle(_ input: String, context: CommandContext) throws -> Bool
}

class BaseCommandHandler: CommandHandler {
    var next: CommandHandler?

    func handle(_ input: String, context: CommandContext) throws -> Bool {
        try next?.handle(input, context: context) ?? false
    }

    func forward(_ input: String, context: CommandContext) throws -> Bool {
        try next?.handle(input, context: context) ?? false
    }

    func parseWords(_ input: String) -> [String] {
        input.split(whereSeparator: { $0 == " " || $0 == "\t" }).map(String.init)
    }
}


final class HelpCommandHandler: BaseCommandHandler {
    override func handle(_ input: String, context: CommandContext) throws -> Bool {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.lowercased() == "help" else {
            return try forward(input, context: context)
        }

        print("""
        Команды:
          help
          add
          list
          delete <id>
          search title <text>
          search author <text>
          search genre <genre>
          search tag <text>
          search year <yyyy>
          exit
        """)

        return true
    }
}

final class ListCommandHandler: BaseCommandHandler {
    override func handle(_ input: String, context: CommandContext) throws -> Bool {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.lowercased() == "list" else {
            return try forward(input, context: context)
        }

        let books = context.shelf.list()
        if books.isEmpty {
            print("Список пуст.")
            return true
        }

        print("Книги (\(books.count)):")
        for (i, b) in books.enumerated() {
            print("\(i + 1)) \(formatBook(b))")
            print("   id: \(b.id)")
        }
        return true
    }

    private func formatBook(_ book: Book) -> String {
        let yearStr = book.publicationYear.map(String.init) ?? "—"
        let tagsStr = book.tags.isEmpty ? "" : " tags: \(book.tags.joined(separator: ", "))"
        return "\(book.title) — \(book.author) (\(yearStr)) [\(book.genre.rawValue)]\(tagsStr)"
    }
}

final class DeleteCommandHandler: BaseCommandHandler {
    override func handle(_ input: String, context: CommandContext) throws -> Bool {
        let parts = parseWords(input)
        guard !parts.isEmpty else {
            return try forward(input, context: context)
        }

        guard parts[0].lowercased() == "delete" else {
            return try forward(input, context: context)
        }

        guard parts.count >= 2 else { throw LibraryError.invalidId }

        let id = parts[1]
        try context.shelf.delete(id: id)
        print("Удалено.")
        return true
    }
}

final class SearchCommandHandler: BaseCommandHandler {
    override func handle(_ input: String, context: CommandContext) throws -> Bool {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = parseWords(trimmed)

        guard !parts.isEmpty else {
            return try forward(input, context: context)
        }

        guard parts[0].lowercased() == "search" else {
            return try forward(input, context: context)
        }

        guard parts.count >= 3 else { throw LibraryError.invalidSearchValue }

        let field = parts[1]
        let value = parts.dropFirst(2).joined(separator: " ")

        let query = try buildSearchQuery(field: field, value: value)
        let found = context.shelf.search(query)

        if found.isEmpty {
            print("Ничего не найдено.")
            return true
        }

        print("Найдено: \(found.count)")
        for (i, b) in found.enumerated() {
            print("\(i + 1)) \(formatBook(b))")
            print("   id: \(b.id)")
        }

        return true
    }

    private func buildSearchQuery(field: String, value: String) throws -> SearchQuery {
        let f = field.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let v = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !v.isEmpty else { throw LibraryError.invalidSearchValue }

        switch f {
        case "title":
            return .title(v)
        case "author":
            return .author(v)
        case "genre":
            guard let g = Genre(rawValue: v) else { throw LibraryError.invalidGenre(v) }
            return .genre(g)
        case "tag":
            return .tag(v)
        case "year":
            guard let y = Int(v) else { throw LibraryError.invalidYear(Int.min) }
            return .year(y)
        default:
            throw LibraryError.invalidSearchField(field)
        }
    }

    private func formatBook(_ book: Book) -> String {
        let yearStr = book.publicationYear.map(String.init) ?? "—"
        let tagsStr = book.tags.isEmpty ? "" : " tags: \(book.tags.joined(separator: ", "))"
        return "\(book.title) — \(book.author) (\(yearStr)) [\(book.genre.rawValue)]\(tagsStr)"
    }
}

final class AddCommandHandler: BaseCommandHandler {
    override func handle(_ input: String, context: CommandContext) throws -> Bool {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.lowercased() == "add" else {
            return try forward(input, context: context)
        }

        let title = promptNonEmpty("Title")
        let author = promptNonEmpty("Author")
        let year = promptOptionalYear("Publication year (Enter чтобы пропустить)")
        let genre = promptGenre("Genre (\(Genre.allCases.map { $0.rawValue }.joined(separator: "/")))")
        let tags = promptTags("Tags (через запятую, можно пусто)")

        let book = Book(
            id: UUID().uuidString,
            title: title,
            author: author,
            publicationYear: year,
            genre: genre,
            tags: tags
        )

        try context.shelf.add(book)
        print("Добавлено. id: \(book.id)")
        return true
    }

    private func prompt(_ label: String) -> String {
        print("\(label): ", terminator: "")
        return readLine() ?? ""
    }

    private func promptNonEmpty(_ label: String) -> String {
        while true {
            let s = prompt(label).trimmingCharacters(in: .whitespacesAndNewlines)
            if !s.isEmpty { return s }
            print("Ошибка: поле не должно быть пустым.")
        }
    }

    private func promptOptionalYear(_ label: String) -> Int? {
        while true {
            let s = prompt(label).trimmingCharacters(in: .whitespacesAndNewlines)
            if s.isEmpty { return nil }
            guard let y = Int(s) else {
                print("Ошибка: год должен быть числом или пустым.")
                continue
            }
            let currentYear = Calendar.current.component(.year, from: Date())
            if y < 1400 || y > currentYear {
                print("Ошибка: год должен быть в диапазоне 1400...\(currentYear).")
                continue
            }
            return y
        }
    }

    private func promptGenre(_ label: String) -> Genre {
        while true {
            let s = prompt(label).trimmingCharacters(in: .whitespacesAndNewlines)
            if let g = Genre(rawValue: s) { return g }
            print("Ошибка: неизвестный жанр. Введите один из: \(Genre.allCases.map { $0.rawValue }.joined(separator: ", ")).")
        }
    }

    private func promptTags(_ label: String) -> [String] {
        let s = prompt(label)
        if s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return [] }
        return s
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}

final class ExitCommandHandler: BaseCommandHandler {
    override func handle(_ input: String, context: CommandContext) throws -> Bool {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.lowercased() == "exit" || trimmed.lowercased() == "quit" else {
            return try forward(input, context: context)
        }

        context.shouldExit = true
        print("Пока.")
        return true
    }
}

final class UnknownCommandHandler: BaseCommandHandler {
    override func handle(_ input: String, context: CommandContext) throws -> Bool {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return true }
        throw LibraryError.invalidCommand(trimmed)
    }
}


final class ConsoleApp {
    private let context: CommandContext
    private let chain: CommandHandler

    init(shelf: BookShelfProtocol) {
        self.context = CommandContext(shelf: shelf)
        self.chain = ConsoleApp.buildChain()
    }

    func run() {
        print("BookShelf CLI")
        print("Введите 'help' для списка команд.\n")

        while !context.shouldExit {
            print("> ", terminator: "")
            guard let line = readLine() else {
                print("\nEOF. Выход.")
                return
            }

            do {
                _ = try chain.handle(line, context: context)
            } catch {
                printError(error)
            }

            print("")
        }
    }

    private func printError(_ error: Error) {
        let msg = (error as? LocalizedError)?.errorDescription ?? String(describing: error)
        print("Ошибка: \(msg)")
    }

    private static func buildChain() -> CommandHandler {
        let help = HelpCommandHandler()
        let add = AddCommandHandler()
        let list = ListCommandHandler()
        let delete = DeleteCommandHandler()
        let search = SearchCommandHandler()
        let exit = ExitCommandHandler()
        let unknown = UnknownCommandHandler()

        help.next = add
        add.next = list
        list.next = delete
        delete.next = search
        search.next = exit
        exit.next = unknown

        return help
    }
}


let shelf: BookShelfProtocol = BookShelf()
let app = ConsoleApp(shelf: shelf)
app.run()
