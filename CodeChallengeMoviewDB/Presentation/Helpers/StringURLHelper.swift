import Foundation

final class StringURLHelper {
    private static let baseImageURL = Bundle.main.infoDictionary?["BASE_IMAGE_URL"] ?? ""
    private static let baseURL = Bundle.main.infoDictionary?["BASE_URL"] ?? ""
    private static let apiKey = Bundle.main.infoDictionary?["API_KEY"] ?? ""
    
    static func movieDetailURLString(movieId: Int) -> String {
        let urlString = "\(baseURL)/movie/\(movieId)?api_key=\(apiKey)"
        return urlString
    }
    
    static func popularMovieURLString(for posterPath: String?, imageWidth: String) -> String {
        guard let posterPath = posterPath else {
            return ""
        }
        return "\(baseImageURL)\(imageWidth)\(posterPath)"
    }
    
    static func popularMoviesURLString(page: Int) -> String {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=en-US&page=\(page)"
        return urlString
    }
    
    static func genreURLString() -> String {
        let urlString = "\(baseURL)/genre/movie/list?api_key=\(apiKey)&language=en-US"
        return urlString
    }
    
}
