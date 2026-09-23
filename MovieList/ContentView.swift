import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.system(size: 50))

            Text("MovieList")
                .font(.largeTitle)
                .bold()

            Text("Результат роботи дивіться в консолі Xcode")
                .multilineTextAlignment(.center)
        }
        .padding()
        .onAppear {
            runMovieScenario()
        }
    }

    func runMovieScenario() {
        let collection = MovieCollection(name: "Мої фільми")

        let movie1 = Movie(
            title: "Interstellar",
            year: 2014,
            genre: .sciFi,
            rating: 8.7,
            note: "Хочу передивитися ще раз"
        )

        let movie2 = Movie(
            title: "The Dark Knight",
            year: 2008,
            genre: .action,
            rating: 9.0
        )

        let movie3 = Movie(
            title: "Shrek",
            year: 2001,
            genre: .animation,
            rating: 7.9,
            note: "Подивитися на вихідних"
        )

        collection.addMovie(movie1)
        collection.addMovie(movie2)
        collection.addMovie(movie3)

        collection.showAllMovies()

        collection.markMovieAsWatched(title: "Interstellar")

        collection.showUnwatchedMovies()

        collection.showNote(for: "Interstellar")
        collection.showNote(for: "The Dark Knight")
    }
}
