import Foundation

class PopularMovie: Equatable {
    static func == (lhs: PopularMovie, rhs: PopularMovie) -> Bool {
        return lhs.posterPath == lhs.posterPath &&
        lhs.overview == lhs.overview &&
        lhs.releaseDate == lhs.releaseDate &&
        lhs.genreIds == lhs.genreIds &&
        lhs.id == lhs.id &&
        lhs.title == lhs.title &&
        lhs.popularity == lhs.popularity &&
        lhs.voteCount == lhs.voteCount &&
        lhs.voteAverage == lhs.voteAverage
    }
    
    let posterPath: String?
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let id: Int
    let title: String
    let popularity: Double
    let voteCount: Int
    let voteAverage: Double
    
    init(posterPath: String?,
                overview: String,
                releaseDate: String,
                genreIds: [Int],
                id: Int,
                title: String,
                popularity: Double,
                voteCount: Int,
                voteAverage: Double) {
        
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.genreIds = genreIds
        self.id = id
        self.title = title
        self.popularity = popularity
        self.voteCount = voteCount
        self.voteAverage = voteAverage
        
    }
}

