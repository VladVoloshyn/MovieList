import Foundation

protocol MovieNetworkRepositoryProtocol {
    func searchMovies(query: String) async throws -> [Movie]
}

final class MovieNetworkRepository: MovieNetworkRepositoryProtocol {
    private let apiService: MovieAPIServiceProtocol

    init(apiService: MovieAPIServiceProtocol) {
        self.apiService = apiService
    }

    func searchMovies(query: String) async throws -> [Movie] {
        let results = try await apiService.searchShows(query: query)

        return results.map { result in
            let show = result.show

            let year: Int

            if let premiered = show.premiered,
               premiered.count >= 4,
               let parsedYear = Int(premiered.prefix(4)) {
                year = parsedYear
            } else {
                year = 0
            }

            let genre = mapGenre(show.genres.first)
            let cleanSummary = stripHTML(show.summary ?? "")

            return Movie(
                title: show.name,
                year: year,
                genre: genre,
                rating: show.rating.average ?? 0.0,
                note: cleanSummary.isEmpty ? nil : cleanSummary
            )
        }
    }

    private func mapGenre(_ genre: String?) -> MovieGenre {
        guard let genre else {
            return .drama
        }

        switch genre.lowercased() {
        case "action":
            return .action

        case "animation":
            return .animation

        case "science-fiction":
            return .sciFi

        case "comedy":
            return .comedy

        case "drama":
            return .drama

        default:
            return .drama
        }
    }

    private func stripHTML(_ text: String) -> String {
        return text.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
    }
}
