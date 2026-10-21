import SwiftUI

struct MovieDetailView: View {
    @Bindable var viewModel: MovieListViewModel
    @Bindable var router: AppRouter

    let movieID: UUID

    @State private var showNote = false

    var body: some View {
        Group {
            if let movie = viewModel.movie(withID: movieID) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        Text(movie.title)
                            .font(.largeTitle)
                            .bold()

                        VStack(alignment: .leading, spacing: 10) {
                            detailRow(title: "Рік", value: "\(movie.year)")
                            detailRow(title: "Жанр", value: movie.genre.rawValue)
                            detailRow(
                                title: "Рейтинг",
                                value: String(format: "%.1f", movie.rating)
                            )
                        }

                        Button {
                            withAnimation(.spring()) {
                                viewModel.markAsWatched(title: movie.title)
                            }
                        } label: {
                            HStack {
                                Image(systemName: movie.isWatched
                                      ? "checkmark.circle.fill"
                                      : "circle")

                                Text(movie.isWatched
                                     ? "Переглянуто"
                                     : "Позначити як переглянутий")
                            }
                            .font(.headline)
                        }

                        if let note = movie.note, !note.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Button {
                                    withAnimation(.easeInOut) {
                                        showNote.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Text(showNote
                                             ? "Сховати нотатку"
                                             : "Показати нотатку")

                                        Image(systemName: showNote
                                              ? "chevron.up"
                                              : "chevron.down")
                                    }
                                }

                                if showNote {
                                    Text(note)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(.thinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }

                        Button {
                            router.showEditMovie(id: movie.id)
                        } label: {
                            Label("Редагувати", systemImage: "pencil")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
                .navigationTitle("Деталі")
                .navigationBarTitleDisplayMode(.inline)

            } else {
                ContentUnavailableView(
                    "Фільм не знайдено",
                    systemImage: "film"
                )
            }
        }
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .bold()
        }
    }
}
