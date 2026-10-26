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

    func toggleWatched(id: UUID) {
        if let index = collection.movies.firstIndex(where: { $0.id == id }) {
            collection.movies[index].isWatched.toggle()
        }
    }

    func updateMovie(id: UUID, movie: Movie) {
        if let index = collection.movies.firstIndex(where: { $0.id == id }) {
            collection.movies[index] = movie
        }
    }
}
