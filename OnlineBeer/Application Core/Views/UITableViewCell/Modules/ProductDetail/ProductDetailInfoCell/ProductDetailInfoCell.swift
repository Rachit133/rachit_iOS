//
//  ProductDetailTopCell.swift
//  Beer Connect
//
//  Created by Apple on 04/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class ProductDetailInfoCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRange: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
