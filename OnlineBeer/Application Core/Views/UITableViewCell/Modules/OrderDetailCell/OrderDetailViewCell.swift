//
//  OrderDetailViewCell.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class OrderDetailViewCell: UITableViewCell {

   @IBOutlet weak var imgOrderDetailProduct: UIImageView!
   @IBOutlet weak var imgCurrencySymbol: UIImageView!
   @IBOutlet weak var lblOrderItemTitle: UILabel!
   @IBOutlet weak var lblOrderQuantity: UILabel!
   @IBOutlet weak var lblLineItemTotal: UILabel!
   @IBOutlet weak var lblOrderItemPrice: UILabel!
   @IBOutlet weak var backView: UIView!
   @IBOutlet weak var lblYouSaved: UILabel!
    @IBOutlet weak var lblRefundQuantity: UILabel!
    @IBOutlet weak var lblRefundTotal: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
