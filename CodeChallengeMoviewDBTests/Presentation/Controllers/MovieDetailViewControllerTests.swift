import XCTest
@testable import CodeChallengeMoviewDB

class MovieDetailViewControllerTests: XCTestCase {
    
    func test_requestMovieDetails_whenViewIsLoaded() {
        let (sut, loader, _) = makeSUT()
        
        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.completions.count, 1)
    }

    func test_loadPopularMoviesCompletion_renderSuccessfullyPopularMoviesLoaded() {
        let (sut, loader, movieUIModel) = makeSUT()
        let movieDetail = MovieDetailHelper.makeMovieDetail()
        
        sut.loadViewIfNeeded()
        loader.complete(with: movieDetail)

        XCTAssertEqual(sut.movieTitle.text, movieUIModel.title)
        XCTAssertEqual(sut.popularity.text, movieUIModel.popularity)
        XCTAssertEqual(sut.genre.text, movieUIModel.genre)
        XCTAssertEqual(sut.releaseYear.text, movieUIModel.releaseYear)
        XCTAssertEqual(sut.score.text, movieUIModel.score)
        XCTAssertEqual(sut.overview.text, movieDetail.overview)
        XCTAssertEqual(sut.homePageLink.text, movieDetail.homepage)
        XCTAssertEqual(sut.runtime.text, String(format: NSLocalizedString("runtime", comment: ""), String(movieDetail.runtime!)))
    }
    
    func test_loadPopularMoviesCompletion_hidesEmptyLabel() {
        let (sut, loader, _) = makeSUT()
        let movieDetail = MovieDetailHelper.makeEmptyMovieDetail()
        
        sut.loadViewIfNeeded()
        loader.complete(with: movieDetail)
        
        XCTAssertTrue(sut.runtime.isHidden)
        XCTAssertTrue(sut.overview.isHidden)
        XCTAssertTrue(sut.homePageLink.isHidden)
    }

    // - MARK: Helpers
    
    private func makeSUT() -> (MovieDetailViewController, MovieDetailLoaderSpy, MovieUIModel) {
        let sut = makeMovieDetailViewController()
        let movieDetailLoaderSpy = MovieDetailLoaderSpy()
        let viewModel = MovieDetailViewModel(movieDetailLoader: movieDetailLoaderSpy, movieDetailMapper: MovieDetailViewDataMapper())
        let movieUIModel = makeMovieUIModel()
        
        sut.movieInfo = movieUIModel
        sut.viewModel = viewModel
        
        validateMemoryLeak(sut)
        validateMemoryLeak(viewModel)
        
        return (sut, movieDetailLoaderSpy, movieUIModel)
    }
    
    private func makeMovieDetailViewController() -> MovieDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
        
    }

    private func makeMovieUIModel() -> MovieUIModel {
        return MovieUIModel(movieId: 1,
                            thumbnailURL: nil,
                            title: "",
                            popularity: "",
                            score: "",
                            releaseYear: "",
                            genre: "")
    }
    
    private class MovieDetailLoaderSpy: MovieDetailLoader {
        var completions = [((MovieDetailLoader.Result) -> Void)]()
        
        func load(url: URL, completion: @escaping (MovieDetailLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func complete(with movieDetail: MovieDetail, atIndex index: Int = 0) {
            completions[index](.success(movieDetail))
        }
    }

}
