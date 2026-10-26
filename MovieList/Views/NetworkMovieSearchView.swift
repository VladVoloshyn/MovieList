import SwiftUI

struct NetworkMovieSearchView: View {
    @Bindable var viewModel: NetworkMovieViewModel
    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        VStack(spacing: 16) {

            HStack {
                TextField(
                    "Введіть назву",
                    text: $viewModel.query
                )
                .textFieldStyle(.roundedBorder)
                .focused($isSearchFieldFocused)
                .submitLabel(.search)
                .onSubmit {
                    performSearch()
                }

                Button("Пошук") {
                    performSearch()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)

            content
        }
        .navigationTitle("Пошук онлайн")
        .scrollDismissesKeyboard(.interactively)
    }

    private func performSearch() {
        isSearchFieldFocused = false

        Task {
            await viewModel.search()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {

        case .idle:
            ContentUnavailableView(
                "Почніть пошук",
                systemImage: "magnifyingglass",
                description: Text(
                    "Введіть назву фільму або серіалу."
                )
            )

        case .loading:
            VStack(spacing: 12) {
                ProgressView()

                Text("Завантаження...")
                    .foregroundStyle(.secondary)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )

        case .success(let movies):
            List(movies, id: \.id) { movie in

                NavigationLink {
                    NetworkMovieDetailView(
                        movie: movie
                    )
                } label: {
                    VStack(
                        alignment: .leading,
                        spacing: 6
                    ) {

                        Text(movie.title)
                            .font(.headline)

                        Text(
                            "\(movie.year) • \(movie.genre.rawValue)"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        if movie.rating == 0 {
                            Text("⭐ Рейтинг відсутній")
                        } else {
                            Text(
                                "⭐ \(movie.rating, specifier: "%.1f")"
                            )
                        }

                        if let note = movie.note,
                           !note.isEmpty {

                            Text(note)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(3)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

        case .empty:
            ContentUnavailableView(
                "Нічого не знайдено",
                systemImage: "magnifyingglass",
                description: Text(
                    "Спробуйте інший запит."
                )
            )

        case .error(let message):
            VStack(spacing: 14) {
                Image(
                    systemName: "exclamationmark.triangle"
                )
                .font(.system(size: 42))

                Text("Помилка")
                    .font(.title2)
                    .bold()

                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Button("Повторити") {
                    Task {
                        await viewModel.retry()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
        }
    }
}
