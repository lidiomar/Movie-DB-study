import XCTest
@testable import CodeChallengeMoviewDB

class PopularMovieViewDataMapperTests: XCTestCase {

    func test_mapToMoveUIModelSuccesfully() {
        let sut = makeSUT()
        let popularMovies = PopularMovieHelper.makePopularMovieRoot().results
        let genre = GenreHelper.makeGenreRoot()
        
        let movieModel = sut.mapToMovieUIModel(popularMovies, genre: genre)
        
        XCTAssertEqual(movieModel[0].title, popularMovies[0].title)
        XCTAssertEqual(movieModel[0].genre, "Action, Crime, Fantasy")
        XCTAssertEqual(movieModel[0].popularity, "Popularity: \(popularMovies[0].popularity)")
        XCTAssertEqual(movieModel[0].releaseYear, "Year: 2016")
        XCTAssertEqual(movieModel[0].thumbnailURL, URL(string: "https://image.tmdb.org/t/p/w300/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg"))
        XCTAssertEqual(movieModel[0].movieId, popularMovies[0].id)
        
        XCTAssertEqual(movieModel[1].title, popularMovies[1].title)
        XCTAssertEqual(movieModel[1].genre, "Action, Thriller")
        XCTAssertEqual(movieModel[1].popularity, "Popularity: \(popularMovies[1].popularity)")
        XCTAssertEqual(movieModel[1].releaseYear, "Year: 2016")
        XCTAssertEqual(movieModel[1].thumbnailURL, URL(string:"https://image.tmdb.org/t/p/w300/lFSSLTlFozwpaGlO31OoUeirBgQ.jpg"))
        XCTAssertEqual(movieModel[1].movieId, popularMovies[1].id)
        
    }
    
    private func makeSUT() -> PopularMovieViewDataMapper {
        let sut = PopularMovieViewDataMapper()
        validateMemoryLeak(sut)
        return sut
    }

}
