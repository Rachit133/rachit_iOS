//
//  CategoryCollectionCell.swift
//  Beer Connect
//
//  Created by Synsoft on 04/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit

class CategoryCollectionCell: UICollectionViewCell {

    @IBOutlet weak var category: UIImageView!
    @IBOutlet weak var lblCatTitle: UILabel!
    @IBOutlet weak var backViewForCat: UIView!
   
   override var isHighlighted: Bool {
       didSet {
           if self.isHighlighted {
            //backgroundColor = ColorConstants.kCOLORLIGHTGREEN
           } else {
            //backgroundColor = ColorConstants.WHITECOLOR
           }
       }
   }

}
