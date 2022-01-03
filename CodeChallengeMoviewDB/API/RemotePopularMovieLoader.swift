import Foundation

class RemotePopularMovieLoader: PopularMovieLoader {
    private var client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(url: URL, completion: @escaping (PopularMovieLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            ResultHelper.prepareResult(result: result,
                                        completion: completion,
                                        mapData: self.map(_:))
        }
    }
    
    private func map(_ remotePopularMovieRoot: RemotePopularMovieRoot) -> PopularMovieRoot {
        let results =  remotePopularMovieRoot.results.map {
            PopularMovie(posterPath: $0.poster_path,
                         overview: $0.overview,
                         releaseDate: $0.release_date,
                         genreIds: $0.genre_ids,
                         id: $0.id,
                         title: $0.title,
                         popularity: $0.popularity,
                         voteCount: $0.vote_count,
                         voteAverage: $0.vote_average)
        }
        
        return PopularMovieRoot(page: remotePopularMovieRoot.page,
                                results: results,
                                totalResults: remotePopularMovieRoot.total_results,
                                totalPages: remotePopularMovieRoot.total_pages)
    }
}
