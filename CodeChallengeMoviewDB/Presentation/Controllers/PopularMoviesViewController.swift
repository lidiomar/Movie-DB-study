import UIKit
import Kingfisher

class PopularMoviesViewController: UITableViewController {
    
    var viewModel: PopularMoviesViewModel?
    private var popularMovieResults: [MovieUIModel] = []
    private var isLoading: Bool = true
    private let lastSectionIndex = 0
    private var lastRowIndex: Int {
        return tableView.numberOfRows(inSection: lastSectionIndex) - 1
    }
    private var spinner: UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.startAnimating()
        return spinner
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        loadPopularMovies()
    }
    
    private func setupTableView() {
        tableView.prefetchDataSource = self
    }
    
    private func bindViewModel() {
        viewModel?.onPopularMovieLoad = { [weak self] movies in
            self?.popularMovieResults.append(contentsOf: movies)
            self?.tableView.reloadData()
            self?.tableView.tableFooterView = nil
            self?.tableView.tableFooterView?.isHidden = true
        }
        
        viewModel?.onLoading = { [weak self] isLoading in
            self?.isLoading = isLoading
        }
        
        viewModel?.onError = { [weak self] in
            self?.alertError()
        }
    }
    
    private func loadPopularMovies() {
        viewModel?.load()
    }
    
    private func alertError() {
        AlertHelper.presentAlertError(self, message: NSLocalizedString("errorMovieLoading", comment: ""))
    }
}

extension PopularMoviesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularMovieResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let popularMovie = popularMovieResults[indexPath.row]
        cell.popularity.text = popularMovie.popularity
        cell.score.text = popularMovie.score
        cell.title.text = popularMovie.title
        cell.releaseYear.text = popularMovie.releaseYear
        cell.genre.text = popularMovie.genre
        
        if let url = popularMovie.thumbnailURL {
            cell.thumbnail?.kf.setImage(with: url)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == lastRowIndex {
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popularMovie = popularMovieResults[indexPath.row]
        
        if let movieDetailViewController = MovieUIComposer.movieDetailViewControllerInstance(movieInfo: popularMovie) {
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        }
    }
}

extension PopularMoviesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.last?.row == lastRowIndex && !isLoading {
            loadPopularMovies()
        }
    }
}
