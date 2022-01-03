import Foundation
@testable import CodeChallengeMoviewDB

class MovieDetailHelper {
    
    static func makeMovieDetail() -> MovieDetail {
        return MovieDetail(homepage: "http://www.suicidesquad.com/",
                           runtime: 123,
                           overview: "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.")
    }
    
    static func makeEmptyMovieDetail() -> MovieDetail {
        return MovieDetail(homepage: nil,
                           runtime: nil,
                           overview: nil)
    }
    
}


