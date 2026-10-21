import Foundation

enum MovieGenre: String, CaseIterable {
    case action = "Бойовик"
    case comedy = "Комедія"
    case drama = "Драма"
    case sciFi = "Фантастика"
    case animation = "Анімація"
}

protocol Watchable {
    var isWatched: Bool { get set }
    mutating func markAsWatched()
}

struct Movie: Watchable {
    let id: UUID
    let title: String
    let year: Int
    let genre: MovieGenre
    var rating: Double
    var isWatched: Bool
    var note: String?

    init(
        id: UUID = UUID(),
        title: String,
        year: Int,
        genre: MovieGenre,
        rating: Double,
        isWatched: Bool = false,
        note: String? = nil
    ) {
        self.id = id
        self.title = title
        self.year = year
        self.genre = genre
        self.rating = rating
        self.isWatched = isWatched
        self.note = note
    }

    mutating func markAsWatched() {
        isWatched = true
    }
}
