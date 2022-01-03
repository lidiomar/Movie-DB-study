import Foundation
import UIKit

class MovieUIComposer {
    
    static func popularMoviesViewControllerInstance() -> PopularMoviesViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: PopularMoviesViewController.self)) as? PopularMoviesViewController
        
        guard let popularMoviesViewController = viewController else {
            return nil
        }
        let client = URLSessionHTTPClient()
        let remoteMovieLoader = RemotePopularMovieLoader(client: client)
        let genreLoader = RemoteGenreLoader(client: client)
        let movieMapper = PopularMovieViewDataMapper()
        let viewModel = PopularMoviesViewModel(popularMovieLoader: remoteMovieLoader, genreLoader: genreLoader, movieMapper: movieMapper)
        popularMoviesViewController.viewModel = viewModel
        
        return popularMoviesViewController
    }
    
    static func movieDetailViewControllerInstance(movieInfo: MovieUIModel?) -> MovieDetailViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController
        
        guard let movieDetailViewController = viewController else {
            return nil
        }
        
        let client = URLSessionHTTPClient()
        let remoteMovieDetailLoader = RemoteMovieDetailLoader(client: client)
        let movieDetailMapper = MovieDetailViewDataMapper()
        movieDetailViewController.viewModel = MovieDetailViewModel(movieDetailLoader: remoteMovieDetailLoader, movieDetailMapper: movieDetailMapper)
        movieDetailViewController.movieInfo = movieInfo
        
        return movieDetailViewController
    }
}
