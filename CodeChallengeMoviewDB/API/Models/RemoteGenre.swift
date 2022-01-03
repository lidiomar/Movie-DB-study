import Foundation

struct RemoteGenreRoot: Decodable {
    let genres: [RemoteGenre]
}

struct RemoteGenre: Decodable {
    let id: Int
    let name: String
}
