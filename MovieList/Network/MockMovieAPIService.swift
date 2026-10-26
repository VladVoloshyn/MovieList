import Foundation

final class MockMovieAPIService: MovieAPIServiceProtocol {
    enum Mode {
        case success
        case empty
        case error
    }

    private let mode: Mode

    init(mode: Mode) {
        self.mode = mode
    }

    func searchShows(query: String) async throws -> [TVMazeSearchResult] {
        switch mode {
        case .success:
            return []

        case .empty:
            return []

        case .error:
            throw NetworkError.transport(
                URLError(.notConnectedToInternet)
            )
        }
    }
}
