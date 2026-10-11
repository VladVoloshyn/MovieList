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

    func markAsWatched(title: String) {
        if let index = movies.firstIndex(where: { $0.title == title }) {
            movies[index].markAsWatched()
        }
    }
}
