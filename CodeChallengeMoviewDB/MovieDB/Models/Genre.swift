import Foundation

class Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name
    }
    
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
