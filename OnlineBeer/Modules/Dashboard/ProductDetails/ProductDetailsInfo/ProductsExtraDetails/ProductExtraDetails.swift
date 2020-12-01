//
//  ProductInfoView.swift
//  Beer Connect
//
//  Created by Synsoft on 13/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class ProductExtraDetails: UIView {
   @IBOutlet var lblProductType: UILabel!
   @IBOutlet var lblProductTypeVal: UILabel!
  
    class func instanceFromNib() -> UIView {
      return UINib(nibName: "ProductExtraDetails", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
      }
}
