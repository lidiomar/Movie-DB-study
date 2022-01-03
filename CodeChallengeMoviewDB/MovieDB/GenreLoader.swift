import Foundation

protocol GenreLoader {
    typealias Result = Swift.Result<GenreRoot, Error>
    func load(url: URL, completion: @escaping (GenreLoader.Result) -> Void)
}
