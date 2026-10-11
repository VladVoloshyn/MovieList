import Foundation

class MovieListViewModel {

    private let repository: MovieRepositoryProtocol
    private var sortingStrategy: MovieSortingStrategy

    init(
        repository: MovieRepositoryProtocol,
        sortingStrategy: MovieSortingStrategy = SortByTitleStrategy()
    ) {
        self.repository = repository
        self.sortingStrategy = sortingStrategy
    }

    func addMovie(_ movie: Movie) {
        repository.addMovie(movie)
    }

    func getMovies() -> [Movie] {
        let movies = repository.getAllMovies()
        return sortingStrategy.sort(movies)
    }

    func markAsWatched(title: String) {
        repository.markAsWatched(title: title)
    }

    func changeSortingStrategy(_ strategy: MovieSortingStrategy) {
        sortingStrategy = strategy
    }
}
