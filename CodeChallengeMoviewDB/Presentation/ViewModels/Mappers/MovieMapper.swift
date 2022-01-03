import Foundation

protocol MovieMapper {
    func mapToMovieUIModel(_ popularMovieResults: [PopularMovie], genre: GenreRoot?) -> [MovieUIModel]
}


