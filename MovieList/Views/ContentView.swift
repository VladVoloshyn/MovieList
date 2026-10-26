import SwiftUI
import Observation

struct ContentView: View {
    @State private var router = AppRouter()
    @State private var viewModel: MovieListViewModel

    init() {
        let collection = MovieCollection(name: "Мої фільми")
        let adapter = MovieCollectionAdapter(collection: collection)

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

        adapter.addMovie(movie1)
        adapter.addMovie(movie2)
        adapter.addMovie(movie3)

        _viewModel = State(
            initialValue: MovieListViewModel(
                repository: adapter,
                sortingStrategy: SortByTitleStrategy()
            )
        )
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            MovieListView(
                viewModel: viewModel,
                router: router
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {

                case .movieDetails(let id):
                    MovieDetailView(
                        viewModel: viewModel,
                        router: router,
                        movieID: id
                    )

                case .onlineSearch:
                    let apiService = MovieAPIService()

                    let networkRepository = MovieNetworkRepository(
                        apiService: apiService
                    )

                    let networkViewModel = NetworkMovieViewModel(
                        repository: networkRepository
                    )

                    NetworkMovieSearchView(
                        viewModel: networkViewModel
                    )
                }
            }
        }
        .sheet(item: $router.presentedSheet) { sheet in
            switch sheet {

            case .addMovie:
                AddMovieView(
                    viewModel: viewModel,
                    router: router
                )

            case .editMovie(let id):
                EditMovieView(
                    viewModel: viewModel,
                    router: router,
                    movieID: id
                )
            }
        }
    }
}
