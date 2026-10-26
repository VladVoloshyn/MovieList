import Foundation

struct TVMazeSearchResult: Decodable {
    let score: Double
    let show: TVMazeShow
}

struct TVMazeShow: Decodable {
    let id: Int
    let name: String
    let premiered: String?
    let genres: [String]
    let rating: TVMazeRating
    let summary: String?
}

struct TVMazeRating: Decodable {
    let average: Double?
}
