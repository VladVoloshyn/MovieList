import Foundation

protocol MovieRepositoryProtocol {
    func getAllMovies() -> [Movie]
    func addMovie(_ movie: Movie)
    func markAsWatched(title: String)
    func updateMovie(id: UUID, movie: Movie)
}
