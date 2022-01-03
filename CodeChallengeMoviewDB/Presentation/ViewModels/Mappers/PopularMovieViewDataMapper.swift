import Foundation

class PopularMovieViewDataMapper: MovieMapper {
    private let imageWidth = "/w300"
    
    func mapToMovieUIModel(_ popularMovieResults: [PopularMovie], genre: GenreRoot?) -> [MovieUIModel] {
        return popularMovieResults.map { MovieUIModel(
            movieId: $0.id,
            thumbnailURL: URL(string: StringURLHelper.popularMovieURLString(for: $0.posterPath, imageWidth: imageWidth)),
            title: $0.title,
            popularity: String(format: NSLocalizedString("popularity", comment: ""), String($0.popularity)),
            score: String(format: NSLocalizedString("score", comment: ""), String($0.voteAverage)),
            releaseYear: String(format: NSLocalizedString("releaseYear", comment: ""), extractYearFrom(String($0.releaseDate))),
            genre: genreDescriptionBy(genre: genre, genreIds: $0.genreIds))
        }
    }
    
    private func extractYearFrom(_ releaseDate: String) -> String {
        let index = 0
        let separatedReleaseDate = releaseDate.split(separator: "-")
        if separatedReleaseDate.indices.contains(index) {
            return String(separatedReleaseDate[index])
        }
        return ""
    }
    
    private func genreDescriptionBy(genre: GenreRoot?, genreIds: [Int]) -> String {
        if let genres = genre?.genres {
            return genres.reduce(into: "") { str, genre in
                if genreIds.contains(genre.id) { str += " \(genre.name)" }
            }.split(separator: " ").joined(separator: ", ")
        }
        return ""
    }
}
