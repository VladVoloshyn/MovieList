import Foundation

protocol MovieRepositoryProtocol {
    func getAllMovies() -> [Movie]
    func addMovie(_ movie: Movie)
    func toggleWatched(id: UUID)
    func updateMovie(id: UUID, movie: Movie)
}
