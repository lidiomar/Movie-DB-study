import Foundation

protocol MovieDetailLoader {
    typealias Result = Swift.Result<MovieDetail, Error>
    func load(url: URL, completion: @escaping (MovieDetailLoader.Result) -> Void)
}
