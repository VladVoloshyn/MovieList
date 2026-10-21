import SwiftUI

struct MovieListView: View {
    @Bindable var viewModel: MovieListViewModel
    @Bindable var router: AppRouter

    var body: some View {
        List(viewModel.movies, id: \.id) { movie in
            Button {
                router.showMovieDetails(id: movie.id)
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(.headline)

                    Text("\(movie.year) • \(movie.genre.rawValue)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack {
                        Text("⭐ \(movie.rating, specifier: "%.1f")")

                        Spacer()

                        if movie.isWatched {
                            Label("Переглянуто", systemImage: "checkmark.circle.fill")
                                .font(.caption)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("MovieList")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.showAddMovie()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
