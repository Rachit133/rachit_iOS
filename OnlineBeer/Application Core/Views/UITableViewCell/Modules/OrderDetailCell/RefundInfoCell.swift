//
//  RefundInfoCell.swift
//  Beer Connect
//
//  Created by Apple on 23/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class RefundInfoCell: UITableViewCell {
   @IBOutlet weak var refundBackView: UIView!
   
   @IBOutlet weak var imgRefund: UIImageView!
   @IBOutlet weak var lblRefundAmt: UILabel!
   @IBOutlet weak var lblRefundDetails: UILabel!
   @IBOutlet weak var lblRefundReason: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
