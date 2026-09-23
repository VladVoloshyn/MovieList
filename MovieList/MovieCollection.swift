import Foundation

class MovieCollection {
    let name: String
    var movies: [Movie]

    init(name: String) {
        self.name = name
        self.movies = []
    }

    func addMovie(_ movie: Movie) {
        movies.append(movie)
        print("Додано фільм: \(movie.title)")
    }

    func showAllMovies() {
        print("\nСписок фільмів:")

        for movie in movies {
            print("\(movie.title) (\(movie.year)) — \(movie.genre.rawValue)")
        }
    }

    func showUnwatchedMovies() {
        let unwatchedMovies = movies.filter { !$0.isWatched }

        print("\nФільми, які ще не переглянуті:")

        for movie in unwatchedMovies {
            print(movie.title)
        }
    }

    func markMovieAsWatched(title: String) {
        if let index = movies.firstIndex(where: { $0.title == title }) {
            movies[index].markAsWatched()
            print("\nФільм \(movies[index].title) позначено як переглянутий.")
        } else {
            print("\nФільм не знайдено.")
        }
    }

    func showNote(for title: String) {
        if let movie = movies.first(where: { $0.title == title }) {
            if let note = movie.note {
                print("Нотатка до \(movie.title): \(note)")
            } else {
                print("Для фільму \(movie.title) нотатки немає.")
            }
        }
    }
}
