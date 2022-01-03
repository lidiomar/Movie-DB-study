import Foundation

protocol MovieDetailMapper {
    func convert(movieDetail: MovieDetail) -> MovieDetailUIModel
}
