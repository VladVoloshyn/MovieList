import SwiftUI

struct EditMovieView: View {
    @Bindable var viewModel: MovieListViewModel
    @Bindable var router: AppRouter

    let movieID: UUID

    @State private var title = ""
    @State private var year = ""
    @State private var rating = ""
    @State private var genre: MovieGenre = .drama
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Основна інформація") {
                    TextField("Назва", text: $title)

                    TextField("Рік", text: $year)
                        .keyboardType(.numberPad)

                    TextField("Рейтинг", text: $rating)
                        .keyboardType(.decimalPad)

                    Picker("Жанр", selection: $genre) {
                        ForEach(MovieGenre.allCases, id: \.self) { genre in
                            Text(genre.rawValue)
                                .tag(genre)
                        }
                    }
                }

                Section("Нотатка") {
                    TextField(
                        "Нотатка",
                        text: $note,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }
            }
            .navigationTitle("Редагування")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Скасувати") {
                        router.dismissSheet()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Зберегти") {
                        saveChanges()
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear {
                loadMovie()
            }
        }
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
        && Int(year) != nil
        && Double(rating.replacingOccurrences(of: ",", with: ".")) != nil
    }

    private func loadMovie() {
        guard let movie = viewModel.movie(withID: movieID) else {
            return
        }

        title = movie.title
        year = String(movie.year)
        rating = String(movie.rating)
        genre = movie.genre
        note = movie.note ?? ""
    }

    private func saveChanges() {
        guard
            let movieYear = Int(year),
            let movieRating = Double(
                rating.replacingOccurrences(of: ",", with: ".")
            )
        else {
            return
        }

        viewModel.updateMovie(
            id: movieID,
            title: title.trimmingCharacters(in: .whitespaces),
            year: movieYear,
            genre: genre,
            rating: movieRating,
            note: note.trimmingCharacters(in: .whitespaces).isEmpty
            ? nil
            : note.trimmingCharacters(in: .whitespaces)
        )

        router.dismissSheet()
    }
}
