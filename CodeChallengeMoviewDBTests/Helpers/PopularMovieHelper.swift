import Foundation
@testable import CodeChallengeMoviewDB

class PopularMovieHelper {
    
    static let numberOfPopularMovies = 2
    
    static func makePopularMovieRoot() -> PopularMovieRoot {
        let results = popularMovieResults()
        let root = PopularMovieRoot(page: 1,
                                    results: results,
                                    totalResults: 19629,
                                    totalPages: 982)
        return root
    }
    
    private static func popularMovieResults() -> [PopularMovie] {
        let popularMovie1 = PopularMovie(posterPath: "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg",
                             overview: "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.",
                             releaseDate: "2016-08-03",
                             genreIds: [14, 28, 80],
                             id: 297761,
                             title: "Suicide Squad",
                             popularity: 48.261451,
                             voteCount: 1466,
                             voteAverage: 5.91)
        
        let popularMovie2 = PopularMovie(posterPath: "/lFSSLTlFozwpaGlO31OoUeirBgQ.jpg",
                             overview: "The most dangerous former operative of the CIA is drawn out of hiding to uncover hidden truths about his past.",
                             releaseDate: "2016-07-27",
                             genreIds: [28,53],
                             id: 324668,
                             title: "Jason Bourne",
                             popularity: 30.690177,
                             voteCount: 649,
                             voteAverage: 5.25)
        
        return [popularMovie1, popularMovie2]
    }
    
}
