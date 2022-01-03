import Foundation

class MovieDetail: Equatable {
    
    static func == (lhs: MovieDetail, rhs: MovieDetail) -> Bool {
        return lhs.homepage == rhs.homepage &&
        lhs.runtime == rhs.runtime &&
        lhs.overview == rhs.overview
    }
    
    let homepage: String?
    let runtime: Int?
    let overview: String?
    
    init(homepage: String?, runtime: Int?, overview: String?) {
        self.homepage = homepage
        self.runtime = runtime
        self.overview = overview
    }
}
