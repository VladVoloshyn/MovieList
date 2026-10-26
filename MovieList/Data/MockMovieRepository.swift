import Foundation

class MockMovieRepository: MovieRepositoryProtocol {
    private var movies: [Movie]

    init(movies: [Movie] = []) {
        self.movies = movies
    }

    func getAllMovies() -> [Movie] {
        return movies
    }

    func addMovie(_ movie: Movie) {
        movies.append(movie)
    }

    func toggleWatched(id: UUID) {
        if let index = movies.firstIndex(where: { $0.id == id }) {
            movies[index].isWatched.toggle()
        }
    }

    func updateMovie(id: UUID, movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == id }) {
            movies[index] = movie
        }
    }
}
