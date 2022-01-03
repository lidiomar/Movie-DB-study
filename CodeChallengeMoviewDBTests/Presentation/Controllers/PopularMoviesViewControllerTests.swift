import XCTest
@testable import CodeChallengeMoviewDB

class PopularMoviesViewControllerTests: XCTestCase {
    
    func test_requestPopularMovies_whenViewIsLoaded() {
        let (sut, popularMovieLoader, genreLoader) = makeSUT()
        
        sut.loadViewIfNeeded()
        genreLoader.complete()
        
        XCTAssertEqual(popularMovieLoader.completions.count, 1)
    }
    
    func test_requestPopularMoview_doesNotRenderPopularMovies() {
        let (sut, _, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfRenderedPopularMovies(), 0)
    }
    
    func test_loadPopularMoviesCompletion_renderSuccessfullyPopularMoviesLoaded() {
        let (sut, popularMovieLoader, genreLoader) = makeSUT()
        
        sut.loadViewIfNeeded()
        genreLoader.complete()
        popularMovieLoader.complete(with: PopularMovieHelper.makePopularMovieRoot())
        
        XCTAssertEqual(sut.numberOfRenderedPopularMovies(), PopularMovieHelper.numberOfPopularMovies)
    }
    
    func test_loadPopularMoviesCompletion_renderSuccessfullyCellWithPopularMovieData() {
        let (sut, popularMovieLoader, genreLoader) = makeSUT()
        let popularMovieRoot = PopularMovieHelper.makePopularMovieRoot()

        sut.loadViewIfNeeded()
        genreLoader.complete()
        popularMovieLoader.complete(with: popularMovieRoot)

        popularMovieRoot.results.enumerated().forEach { index, popularMovie in
            let cell = sut.popularMoviewCell(atRow: index) as! MovieTableViewCell
            XCTAssertEqual(cell.popularity.text, "\(popularMovie.popularity)")
            XCTAssertEqual(cell.score.text, "\(popularMovie.voteAverage)")
            XCTAssertEqual(cell.title.text, popularMovie.title)
            XCTAssertEqual(cell.releaseYear.text, popularMovie.releaseDate)
        }
    }
    
    func test_showIndicator_whenLastElementIsShown() {
        let (sut, popularMovieLoader, genreLoader) = makeSUT()

        sut.loadViewIfNeeded()
        genreLoader.complete()
        popularMovieLoader.complete(with: PopularMovieHelper.makePopularMovieRoot())
        sut.simulateLastTableViewCellWillBeDisplayed()

        XCTAssertFalse(sut.indicatorView!.isHidden)
    }

    func test_assertIndicatorIsNil_whenPopularMoviesLoaded() {
        let (sut, popularMovieLoader, genreLoader) = makeSUT()

        sut.loadViewIfNeeded()
        genreLoader.complete()
        popularMovieLoader.complete(with: PopularMovieHelper.makePopularMovieRoot())

        XCTAssertNil(sut.indicatorView)
    }

    func test_callLoadNextPopularMoviePage_whenLastElementIsShown() {
        let (sut, popularMovieLoader, genreLoader) = makeSUT()

        sut.loadViewIfNeeded()
        genreLoader.complete()
        popularMovieLoader.complete(with: PopularMovieHelper.makePopularMovieRoot())
        sut.simulatePreFetchRowsAt()

        XCTAssertEqual(popularMovieLoader.completions.count, 2)
    }
    
    func test_callMoviewDetailViewController_whenRowIsSelected() {
        let (sut, popularMovieLoader, genreLoader) = makeSUT()
        let navigationViewController = UINavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()
        genreLoader.complete()
        popularMovieLoader.complete(with: PopularMovieHelper.makePopularMovieRoot())
        
        sut.simulateDidSelectRow()
        RunLoop.current.run(until: Date())
        
        XCTAssertEqual(navigationViewController.viewControllers.count, 2)
        let pushedViewController = navigationViewController.viewControllers.last
        XCTAssertTrue(pushedViewController is MovieDetailViewController)
    }
    
    // - MARK: Helpers
    
    private func makeSUT() -> (PopularMoviesViewController, PopularMovieLoaderSpy, GenreLoaderSpy) {
        let sut = makePopularMoviesViewController()
        let popularMovieLoaderSpy = PopularMovieLoaderSpy()
        let genreLoaderSpy = GenreLoaderSpy()
        let popularMovieMapper = PopularMovieViewMapperMock()
        let viewModel = PopularMoviesViewModel(popularMovieLoader: popularMovieLoaderSpy, genreLoader: genreLoaderSpy, movieMapper: popularMovieMapper)
        
        sut.viewModel = viewModel
        validateMemoryLeak(sut)
        validateMemoryLeak(viewModel)
        
        return (sut, popularMovieLoaderSpy, genreLoaderSpy)
    }
    
    private func makePopularMoviesViewController() -> PopularMoviesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "PopularMoviesViewController") as! PopularMoviesViewController
    }
    
    private class PopularMovieLoaderSpy: PopularMovieLoader {
        var completions = [((PopularMovieLoader.Result) -> Void)]()
        
        func load(url: URL, completion: @escaping (PopularMovieLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func complete(with popularMovieRoot: PopularMovieRoot, atIndex index: Int = 0) {
            completions[index](.success(popularMovieRoot))
        }
    }
    
    private class GenreLoaderSpy: GenreLoader {
        var completion: ((GenreLoader.Result) -> Void)?
        
        func load(url: URL, completion: @escaping (Result<GenreRoot, Error>) -> Void) {
            self.completion = completion
        }
        
        func complete() {
            completion?(.success(GenreRoot(genres: [])))
        }
    }
    
    private class PopularMovieViewMapperMock: MovieMapper {
        func mapToMovieUIModel(_ popularMovieResults: [PopularMovie], genre: GenreRoot?) -> [MovieUIModel] {
            return popularMovieResults.map { MovieUIModel(
                movieId: $0.id,
                thumbnailURL: URL(string: "http://any-url.com"),
                title: $0.title,
                popularity: String($0.popularity),
                score: String($0.voteAverage),
                releaseYear: $0.releaseDate,
                genre: "")
            }
        }
    }
}

extension PopularMoviesViewController {
    
    private var popularMoviesSection: Int {
        return 0
    }
    
    private var lastIndexPath: IndexPath {
        let row = tableView.numberOfRows(inSection: popularMoviesSection) - 1
        return IndexPath(row: row, section: popularMoviesSection)
    }
    
    var indicatorView: UIView? {
        return tableView.tableFooterView
    }
    
    func simulateLastTableViewCellWillBeDisplayed() {
        let delegate = tableView.delegate
        delegate?.tableView?(tableView, willDisplay: UITableViewCell(), forRowAt: lastIndexPath)
    }
    
    func simulatePreFetchRowsAt() {
        let prefetchDataSource = tableView.prefetchDataSource
        prefetchDataSource?.tableView(tableView, prefetchRowsAt: [lastIndexPath])
    }
    
    func numberOfRenderedPopularMovies() -> Int {
        return tableView.numberOfRows(inSection: popularMoviesSection)
    }
    
    func popularMoviewCell(atRow row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let indexPath = IndexPath(row: row, section: popularMoviesSection)
        return dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func simulateDidSelectRow(atRow row: Int = 0) {
        let delegate = tableView.delegate
        delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: row, section: popularMoviesSection))
    }
}
