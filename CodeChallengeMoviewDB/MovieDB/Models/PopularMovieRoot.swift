import Foundation

class PopularMovieRoot: Equatable {
    static func == (lhs: PopularMovieRoot, rhs: PopularMovieRoot) -> Bool {
        return lhs.page == rhs.page &&
        lhs.results == rhs.results &&
        lhs.totalResults == rhs.totalResults &&
        lhs.totalPages == rhs.totalPages
    }
    
    let page: Int
    let results: [PopularMovie]
    let totalResults: Int
    let totalPages: Int
    
    init(page: Int,
         results: [PopularMovie],
         totalResults: Int,
         totalPages: Int) {
        
        self.page = page
        self.results = results
        self.totalResults = totalResults
        self.totalPages = totalPages
        
    }
}
