import SwiftUI

struct ContentView: View {

    private let viewModel: MovieListViewModel

    init() {
        let collection = MovieCollection(name: "Мої фільми")
        let adapter = MovieCollectionAdapter(collection: collection)

        self.viewModel = MovieListViewModel(
            repository: adapter,
            sortingStrategy: SortByTitleStrategy()
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.system(size: 50))

            Text("MovieList")
                .font(.largeTitle)
                .bold()

            Text("MVVM + Builder + Adapter + Strategy")
                .multilineTextAlignment(.center)

            Text("Результат роботи дивіться в консолі Xcode")
                .multilineTextAlignment(.center)
        }
        .padding()
        .onAppear {
            runScenario()
        }
    }

    private func runScenario() {

        print("\n=== Практична робота 2 ===")

        let movie1 = MovieBuilder()
            .setTitle("Interstellar")
            .setYear(2014)
            .setGenre(.sciFi)
            .setRating(8.7)
            .setNote("Хочу передивитися ще раз")
            .build()

        let movie2 = MovieBuilder()
            .setTitle("The Dark Knight")
            .setYear(2008)
            .setGenre(.action)
            .setRating(9.0)
            .build()

        let movie3 = MovieBuilder()
            .setTitle("Shrek")
            .setYear(2001)
            .setGenre(.animation)
            .setRating(7.9)
            .build()

        viewModel.addMovie(movie1)
        viewModel.addMovie(movie2)
        viewModel.addMovie(movie3)

        print("\nСортування за назвою:")

        for movie in viewModel.getMovies() {
            print("\(movie.title) — \(movie.rating)")
        }

        viewModel.changeSortingStrategy(
            SortByRatingStrategy()
        )

        print("\nСортування за рейтингом:")

        for movie in viewModel.getMovies() {
            print("\(movie.title) — \(movie.rating)")
        }

        viewModel.markAsWatched(
            title: "Interstellar"
        )

        print("\nInterstellar позначено як переглянутий.")
    }
}
