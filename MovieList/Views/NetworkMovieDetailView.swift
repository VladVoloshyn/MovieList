import SwiftUI

struct NetworkMovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text(movie.title)
                    .font(.largeTitle)
                    .bold()

                VStack(spacing: 14) {
                    detailRow(
                        title: "Рік",
                        value: movie.year == 0
                            ? "Невідомо"
                            : "\(movie.year)"
                    )

                    detailRow(
                        title: "Жанр",
                        value: movie.genre.rawValue
                    )

                    detailRow(
                        title: "Рейтинг",
                        value: movie.rating == 0
                            ? "Відсутній"
                            : String(format: "%.1f", movie.rating)
                    )
                }

                if let note = movie.note,
                   !note.isEmpty {

                    Divider()

                    Text("Опис")
                        .font(.title2)
                        .bold()

                    Text(note)
                        .foregroundStyle(.secondary)
                        .lineSpacing(5)
                }
            }
            .padding()
        }
        .navigationTitle("Деталі")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .bold()
                .multilineTextAlignment(.trailing)
        }
    }
}
