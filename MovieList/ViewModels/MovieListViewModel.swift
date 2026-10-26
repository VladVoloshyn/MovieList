import Foundation
import Observation

@Observable
class MovieListViewModel {
    private let repository: MovieRepositoryProtocol
    private var sortingStrategy: MovieSortingStrategy

    var movies: [Movie] = []

    init(
        repository: MovieRepositoryProtocol,
        sortingStrategy: MovieSortingStrategy = SortByTitleStrategy()
    ) {
        self.repository = repository
        self.sortingStrategy = sortingStrategy
        loadMovies()
    }

    func loadMovies() {
        movies = sortingStrategy.sort(repository.getAllMovies())
    }

    func addMovie(_ movie: Movie) {
        repository.addMovie(movie)
        loadMovies()
    }

    func getMovies() -> [Movie] {
        return movies
    }

    func toggleWatched(id: UUID) {
        repository.toggleWatched(id: id)
        loadMovies()
    }

    func changeSortingStrategy(_ strategy: MovieSortingStrategy) {
        sortingStrategy = strategy
        loadMovies()
    }

    func movie(withID id: UUID) -> Movie? {
        movies.first { $0.id == id }
    }

    func updateMovie(
        id: UUID,
        title: String,
        year: Int,
        genre: MovieGenre,
        rating: Double,
        note: String?
    ) {
        guard let oldMovie = movie(withID: id) else {
            return
        }

        var updatedMovie = Movie(
            id: oldMovie.id,
            title: title,
            year: year,
            genre: genre,
            rating: rating,
            note: note
        )

        if oldMovie.isWatched {
            updatedMovie.markAsWatched()
        }

        repository.updateMovie(
            id: id,
            movie: updatedMovie
        )

        loadMovies()
    }
}
