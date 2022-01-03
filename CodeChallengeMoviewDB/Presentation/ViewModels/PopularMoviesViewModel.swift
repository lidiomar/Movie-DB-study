import Foundation

class PopularMoviesViewModel {
    private var popularMovieLoader: PopularMovieLoader
    private var genreLoader: GenreLoader
    private var movieMapper: MovieMapper
    private var genre: GenreRoot?
    private var page = 0
    private var numberOfPages: Int?
    private var popularMoviesUrl: URL? {
        return URL(string: StringURLHelper.popularMoviesURLString(page: page))
    }
    private var genreUrl: URL? {
        return URL(string: StringURLHelper.genreURLString())
    }
    private var shouldLoadGenre: Bool {
        return genre == nil
    }
    
    var onPopularMovieLoad: (([MovieUIModel]) -> Void)?
    var onError: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    init(popularMovieLoader: PopularMovieLoader, genreLoader: GenreLoader, movieMapper: MovieMapper) {
        self.popularMovieLoader = popularMovieLoader
        self.genreLoader = genreLoader
        self.movieMapper = movieMapper
    }
    
    func load() {
        if shouldLoadGenre {
            loadGenre { [weak self] in self?.loadPopularMovies() }
        } else {
            loadPopularMovies()
        }
    }
    
    private func loadGenre(completion: @escaping (() -> Void)) {
        guard let url = genreUrl else {
            completion()
            return
        }
        
        genreLoader.load(url: url) { [weak self] result in
            switch result {
            case let .success(genre):
                self?.genre = genre
            default:
                self?.onError?()
            }
            completion()
        }
    }
    
    private func shouldLoadPopularMovies() -> Bool {
        if let numberOfPages = numberOfPages, page > numberOfPages {
            return false
        }
        return true
    }
    
    private func loadPopularMovies() {
        page += 1
        guard let url = popularMoviesUrl, shouldLoadPopularMovies() else { return }

        onLoading?(true)
        popularMovieLoader.load(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case  let .success(popularMovieRoot):
                self.numberOfPages = popularMovieRoot.totalPages
                let result = self.movieMapper.mapToMovieUIModel(popularMovieRoot.results, genre: self.genre)
                self.onPopularMovieLoad?(result)
            case .failure:
                self.page -= 1
                self.onError?()
            }
            self.onLoading?(false)
        }
    }
}
