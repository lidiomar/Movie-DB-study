import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak private(set) var thumbnail: UIImageView!
    @IBOutlet weak private(set) var movieTitle: UILabel!
    @IBOutlet weak private(set) var popularity: UILabel!
    @IBOutlet weak private(set) var genre: UILabel!
    @IBOutlet weak private(set) var releaseYear: UILabel!
    @IBOutlet weak private(set) var score: UILabel!
    @IBOutlet weak private(set) var runtime: UILabel!
    @IBOutlet weak private(set) var overview: UILabel!
    @IBOutlet weak private(set) var homePageLink: UITextView!
    
    var movieInfo: MovieUIModel?
    var viewModel: MovieDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        loadMovieDetail()
    }
    
    private func bindViewModel() {
        viewModel?.onMovieDetailLoad = { [weak self] movieDetail in
            self?.setupMovieDetailInfo(movieDetail: movieDetail)
        }
        
        viewModel?.onError = { [weak self] in
            self?.alertError()
        }
    }
    
    private func alertError() {
        AlertHelper.presentAlertError(self, message: NSLocalizedString("errorDetailLoading", comment: ""))
    }
    
    private func loadMovieDetail() {
        guard let movieId = movieInfo?.movieId else { return }
        viewModel?.loadMovieDetail(movieId: movieId)
    }
    
    private func setupMovieDetailInfo(movieDetail: MovieDetailUIModel) {
        guard let movieInfo = movieInfo else { return }
        
        if let url = movieInfo.thumbnailURL {
            thumbnail.kf.setImage(with: url)
        }
        
        movieTitle.text = movieInfo.title
        popularity.text = movieInfo.popularity
        score.text = movieInfo.score
        releaseYear.text = movieInfo.releaseYear
        genre.text = movieInfo.genre
        
        setupLabel(runtime, with: movieDetail.runtime)
        setupLabel(overview, with: movieDetail.overview)
        setupHomepageLink(link: movieDetail.homepage)
    }
    
    private func setupHomepageLink(link: String?) {
        guard let link = link else {
            homePageLink.isHidden = true
            return
        }
        homePageLink.text = link
        homePageLink.textContainer.maximumNumberOfLines = 2
        homePageLink.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    private func setupLabel(_ label: UILabel, with labelDescription: String) {
        guard !labelDescription.isEmpty else {
            label.isHidden = true
            return
        }
        label.text = labelDescription
    }
}
