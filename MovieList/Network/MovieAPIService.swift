import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case transport(Error)
    case invalidResponse
    case httpError(Int)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Не вдалося сформувати адресу запиту."

        case .transport:
            return "Не вдалося підключитися до сервера. Перевірте інтернет-з'єднання."

        case .invalidResponse:
            return "Сервер повернув некоректну відповідь."

        case .httpError(let statusCode):
            return "Помилка сервера. HTTP-код: \(statusCode)."

        case .decoding:
            return "Не вдалося обробити дані, отримані із сервера."
        }
    }
}

protocol MovieAPIServiceProtocol {
    func searchShows(query: String) async throws -> [TVMazeSearchResult]
}

final class MovieAPIService: MovieAPIServiceProtocol {
    private let session: URLSession
    private let baseURL = "https://api.tvmaze.com"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func searchShows(query: String) async throws -> [TVMazeSearchResult] {
        guard var components = URLComponents(
            string: "\(baseURL)/search/shows"
        ) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 15
        )

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.transport(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(
                [TVMazeSearchResult].self,
                from: data
            )
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
