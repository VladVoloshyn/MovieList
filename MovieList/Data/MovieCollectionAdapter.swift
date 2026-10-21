import Foundation

class MovieCollectionAdapter: MovieRepositoryProtocol {
    private let collection: MovieCollection

    init(collection: MovieCollection) {
        self.collection = collection
    }

    func getAllMovies() -> [Movie] {
        return collection.movies
    }

    func addMovie(_ movie: Movie) {
        collection.addMovie(movie)
    }

    func markAsWatched(title: String) {
        collection.markMovieAsWatched(title: title)
    }

    func updateMovie(id: UUID, movie: Movie) {
        if let index = collection.movies.firstIndex(where: { $0.id == id }) {
            collection.movies[index] = movie
        }
    }
}
