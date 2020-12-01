//
//  ProductInfoView.swift
//  Beer Connect
//
//  Created by Synsoft on 13/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class ProductInfoView: UIView {
   @IBOutlet var lblProductName: UILabel!
   @IBOutlet var lblProductRange: UILabel!
   @IBOutlet var lblProductDiscount: UILabel!
  
    class func instanceFromNib() -> UIView {
      return UINib(nibName: "ProductInfo", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
      }
}
