import Foundation

class GenreRoot: Equatable {
    static func == (lhs: GenreRoot, rhs: GenreRoot) -> Bool {
        return lhs.genres == rhs.genres
    }
    
    let genres: [Genre]
    
    init(genres: [Genre]) {
        self.genres = genres
    }
}
