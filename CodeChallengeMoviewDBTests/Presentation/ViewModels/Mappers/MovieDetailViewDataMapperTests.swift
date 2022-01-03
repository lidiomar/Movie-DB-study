import XCTest
@testable import CodeChallengeMoviewDB

class MovieDetailViewDataMapperTests: XCTestCase {
    
    func test_mapToMoveUIModelSuccesfully() {
        let sut = MovieDetailViewDataMapper()
        let movieDetail = MovieDetailHelper.makeMovieDetail()
        
        let movieDetailUIModel = sut.convert(movieDetail: movieDetail)
        
        XCTAssertEqual(movieDetailUIModel.runtime, "Runtime: \(String(movieDetail.runtime!)) minutes")
        XCTAssertEqual(movieDetailUIModel.homepage, movieDetail.homepage)
        XCTAssertEqual(movieDetailUIModel.overview, movieDetail.overview)
    }
    
    private func makeSUT() -> MovieDetailViewDataMapper {
        let sut = MovieDetailViewDataMapper()
        validateMemoryLeak(sut)
        return sut
    }
}

