//
//  BestCategoryCell.swift
//  Beer Connect
//
//  Created by Synsoft on 11/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class BestCategoryCell: UITableViewCell {

   @IBOutlet weak var backProductView: UIView!
   @IBOutlet weak var bestSellerCollectionView: UICollectionView!
   @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout?
 
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
