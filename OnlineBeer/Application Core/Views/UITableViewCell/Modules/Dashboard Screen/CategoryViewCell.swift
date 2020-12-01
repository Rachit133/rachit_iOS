//
//  DashboardSearchDataCell.swift
//  CVDelight_Partner
//
//  Created by apple on 28/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CategoryViewCell: UITableViewCell {
   
   @IBOutlet weak var catCollectionView: UICollectionView!
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
