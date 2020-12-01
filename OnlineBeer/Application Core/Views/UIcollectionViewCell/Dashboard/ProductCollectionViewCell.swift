//
//  ProductCollectionViewCell.swift
//  Beer Connect
//
//  Created by Synsoft on 13/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var catImage: UIImageView!
  @IBOutlet weak var lblCatTitle: UILabel!
  @IBOutlet weak var backView: UIView! {
      didSet {
         self.backView.layer.backgroundColor = UIColor.lightPeriwinkle.cgColor
         self.backView.layer.masksToBounds =  true
      }
   }
    
    
   
}
