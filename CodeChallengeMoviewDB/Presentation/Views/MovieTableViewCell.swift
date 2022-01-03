import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet private(set) var thumbnail: UIImageView!
    @IBOutlet private(set) var title: UILabel!
    @IBOutlet private(set) var popularity: UILabel!
    @IBOutlet private(set) var score: UILabel!
    @IBOutlet private(set) var releaseYear: UILabel!
    @IBOutlet private(set) var genre: UILabel!
}
