//
//  PaymentMethodCell.swift
//  Beer Connect
//
//  Created by Synsoft on 27/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

   @IBOutlet weak var imgPaymentTitle: UIImageView!
   @IBOutlet weak var lblPaymentTitle: UILabel!
   @IBOutlet weak var lblPaymentDescription: UILabel!
   @IBOutlet weak var btnPaymentSelect: UIButton!
   @IBOutlet weak var imgPaymentBg: UIImageView!
   
   weak var delegate: PaymentMethodProtocol? = nil
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}


extension PaymentMethodCell {
   @IBAction func selectPaymentMethodType(_ sender: UIButton) {
      if self.delegate != nil {
         self.delegate?.onPaymentMethodTapped(methodType: "Cash only")
      }
   }
}
