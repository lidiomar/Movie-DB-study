import Foundation

class MovieDetailViewModel {
    private var movieDetailLoader: MovieDetailLoader
    private var movieDetailMapper: MovieDetailMapper
    var onMovieDetailLoad: ((MovieDetailUIModel) -> Void)?
    var onError: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    init(movieDetailLoader: MovieDetailLoader, movieDetailMapper: MovieDetailMapper) {
        self.movieDetailLoader = movieDetailLoader
        self.movieDetailMapper = movieDetailMapper
    }
    
    func loadMovieDetail(movieId: Int) {
        guard let url = URL(string: StringURLHelper.movieDetailURLString(movieId: movieId)) else { return }
        onLoading?(true)
        movieDetailLoader.load(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case  let .success(movieDetail):
                let movieDetail = self.movieDetailMapper.convert(movieDetail: movieDetail)
                self.onMovieDetailLoad?(movieDetail)
            case .failure:
                self.onError?()
            }
            self.onLoading?(false)
        }
    }
    
    private func convert(movieDetail: MovieDetail) -> MovieDetailUIModel {
        var runtimeString = ""
        if let runtime = movieDetail.runtime {
            runtimeString = String(runtime)
        }
        
        return MovieDetailUIModel(homepage: movieDetail.homepage,
                                  runtime: runtimeString,
                                  overview: movieDetail.overview ?? "")
    }
}
