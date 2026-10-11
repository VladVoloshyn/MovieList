import Foundation

class MovieBuilder {
    private var title: String = ""
    private var year: Int = 0
    private var genre: MovieGenre = .drama
    private var rating: Double = 0.0
    private var note: String?

    func setTitle(_ title: String) -> MovieBuilder {
        self.title = title
        return self
    }

    func setYear(_ year: Int) -> MovieBuilder {
        self.year = year
        return self
    }

    func setGenre(_ genre: MovieGenre) -> MovieBuilder {
        self.genre = genre
        return self
    }

    func setRating(_ rating: Double) -> MovieBuilder {
        self.rating = rating
        return self
    }

    func setNote(_ note: String?) -> MovieBuilder {
        self.note = note
        return self
    }

    func build() -> Movie {
        return Movie(
            title: title,
            year: year,
            genre: genre,
            rating: rating,
            note: note
        )
    }
}
