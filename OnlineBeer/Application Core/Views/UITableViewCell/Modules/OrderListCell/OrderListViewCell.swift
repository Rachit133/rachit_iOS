//
//  OrderListViewCell.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class OrderListViewCell: UITableViewCell {

   @IBOutlet weak var imgOrderProduct: UIImageView!
   @IBOutlet weak var lblInvoiceNo: UILabel!
   @IBOutlet weak var lblOrderTotalAmt: UILabel!
   @IBOutlet weak var lblOrderStatus: UILabel!
   @IBOutlet weak var btnOrderDeliveryDate: UIButton!
   @IBOutlet weak var backView: UIView!
   @IBOutlet weak var lblOrderDate: UILabel!
   @IBOutlet weak var deliveryDateStackView: UIStackView!
   @IBOutlet weak var orderDateStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
