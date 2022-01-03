import Foundation

class RemoteGenreLoader: GenreLoader {
    private var client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(url: URL, completion: @escaping (GenreLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            ResultHelper.prepareResult(result: result,
                                        completion: completion,
                                        mapData: self.map(_:))
        }
    }
    
    private func map(_ remoteGenreRoot: RemoteGenreRoot) -> GenreRoot {
        let genres = remoteGenreRoot.genres.map { Genre(id: $0.id, name: $0.name) }
        return GenreRoot(genres: genres)
    }
}
