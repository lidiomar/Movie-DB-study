import Foundation

class MovieDetailViewDataMapper: MovieDetailMapper {
    func convert(movieDetail: MovieDetail) -> MovieDetailUIModel {
        var runtimeString = ""
        if let runtime = movieDetail.runtime {
            runtimeString = String(format: NSLocalizedString("runtime", comment: ""), String(runtime))
        }
        
        return MovieDetailUIModel(homepage: movieDetail.homepage,
                                  runtime: runtimeString,
                                  overview: movieDetail.overview ?? "")
    }
}
