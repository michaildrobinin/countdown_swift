import UIKit

class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var timer: Timer?
    
    var model:EventModel?

    @IBOutlet weak var content1View: UIView!
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var blur_imgView: UIVisualEffectView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
