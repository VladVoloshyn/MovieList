import Foundation

enum MovieGenre: String {
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
        title: String,
        year: Int,
        genre: MovieGenre,
        rating: Double,
        note: String? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.year = year
        self.genre = genre
        self.rating = rating
        self.isWatched = false
        self.note = note
    }

    mutating func markAsWatched() {
        isWatched = true
    }
}
