import Foundation

protocol PopularMovieLoader {
    typealias Result = Swift.Result<PopularMovieRoot, Error>
    func load(url: URL, completion: @escaping (PopularMovieLoader.Result) -> Void)
}
