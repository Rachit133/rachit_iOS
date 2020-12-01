//
//  DealerCategoryCellTableViewCell.swift
//  Beer Connect
//
//  Created by Synsoft on 11/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class DealProductsCell: UITableViewCell {

   @IBOutlet weak var productTitleImage: UIImageView!
   @IBOutlet weak var lblProductTitle: UILabel!
   @IBOutlet weak var lblProductQuantity: UILabel!
   @IBOutlet weak var lblProductPrice: UILabel!
   @IBOutlet weak var lblDiscountPercentage: UILabel!
   @IBOutlet weak var imgDiscountBack: UIImageView!
   @IBOutlet weak var discountPrice: UILabel!
   @IBOutlet weak var disCountView: UIView! 
   @IBOutlet weak var dealsBackView: UIView! {
      didSet {
         self.layer.cornerRadius = 8
         self.layer.shadowColor = UIColor.black8.cgColor
         self.layer.shadowOffset = CGSize.zero
         self.layer.shadowOpacity = 22.0
         self.layer.shadowRadius = 12.0
         self.layer.masksToBounds =  false
      }
   }

   
   override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}


