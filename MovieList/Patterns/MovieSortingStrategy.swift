import Foundation

protocol MovieSortingStrategy {
    func sort(_ movies: [Movie]) -> [Movie]
}

class SortByTitleStrategy: MovieSortingStrategy {
    func sort(_ movies: [Movie]) -> [Movie] {
        return movies.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }
}

class SortByRatingStrategy: MovieSortingStrategy {
    func sort(_ movies: [Movie]) -> [Movie] {
        return movies.sorted {
            $0.rating > $1.rating
        }
    }
}

class SortByYearStrategy: MovieSortingStrategy {
    func sort(_ movies: [Movie]) -> [Movie] {
        return movies.sorted {
            $0.year > $1.year
        }
    }
}
