import Foundation

class RemoteMovieDetailLoader: MovieDetailLoader {
    private var client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(url: URL, completion: @escaping (MovieDetailLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            ResultHelper.prepareResult(result: result,
                                        completion: completion,
                                        mapData: self.convert(_:))
        }
    }
    
    private func convert(_ remoteMovieDetail: RemoteMovieDetail) -> MovieDetail {
        return MovieDetail(homepage: remoteMovieDetail.homepage,
                           runtime: remoteMovieDetail.runtime,
                           overview: remoteMovieDetail.overview)
    }
}

