import SwiftUI

struct AddMovieView: View {
    @Bindable var viewModel: MovieListViewModel
    @Bindable var router: AppRouter

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
                        "Наприклад: хочу передивитися",
                        text: $note,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }
            }
            .navigationTitle("Новий фільм")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Скасувати") {
                        router.dismissSheet()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Зберегти") {
                        saveMovie()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
        && Int(year) != nil
        && Double(rating.replacingOccurrences(of: ",", with: ".")) != nil
    }

    private func saveMovie() {
        guard
            let movieYear = Int(year),
            let movieRating = Double(
                rating.replacingOccurrences(of: ",", with: ".")
            )
        else {
            return
        }

        let movie = MovieBuilder()
            .setTitle(title.trimmingCharacters(in: .whitespaces))
            .setYear(movieYear)
            .setGenre(genre)
            .setRating(movieRating)
            .setNote(
                note.trimmingCharacters(in: .whitespaces).isEmpty
                ? nil
                : note.trimmingCharacters(in: .whitespaces)
            )
            .build()

        viewModel.addMovie(movie)
        router.dismissSheet()
    }
}
