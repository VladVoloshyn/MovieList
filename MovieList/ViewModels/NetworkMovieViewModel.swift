import Foundation
import Observation

enum NetworkMovieState {
    case idle
    case loading
    case success([Movie])
    case empty
    case error(String)
}

@MainActor
@Observable
final class NetworkMovieViewModel {
    private let repository: MovieNetworkRepositoryProtocol

    var state: NetworkMovieState = .idle
    var query: String = "Dark"

    init(repository: MovieNetworkRepositoryProtocol) {
        self.repository = repository
    }

    func search() async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else {
            state = .empty
            return
        }

        state = .loading

        do {
            let movies = try await repository.searchMovies(query: trimmedQuery)

            if movies.isEmpty {
                state = .empty
            } else {
                state = .success(movies)
            }

        } catch {
            if let localizedError = error as? LocalizedError,
               let description = localizedError.errorDescription {
                state = .error(description)
            } else {
                state = .error("Сталася невідома помилка.")
            }
        }
    }

    func retry() async {
        await search()
    }
}
