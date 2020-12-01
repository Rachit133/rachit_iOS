
import UIKit

class ProductDetailAddToCartCell: UITableViewCell {

    @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet weak var lblRegularPrice: UILabel!
    @IBOutlet weak var lblSalePrice: UILabel!
    @IBOutlet weak var imgDoller: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductQty: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
