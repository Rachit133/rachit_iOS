//
//  FetchWishlistCell.swift
//  Beer Connect
//
//  Created by Synsoft on 02/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class FetchWishlistCell: UITableViewCell {

   @IBOutlet weak var titleImage: UIImageView!
   @IBOutlet weak var lblTitle: UILabel!
   @IBOutlet weak var lblPrice: UILabel!
   @IBOutlet weak var btnPrice: UIButton!
   @IBOutlet weak var lblQuantityCount: UILabel!
   @IBOutlet weak var backFetchWishlistView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
