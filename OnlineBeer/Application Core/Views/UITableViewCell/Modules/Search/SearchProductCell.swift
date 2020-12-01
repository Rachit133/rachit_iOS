//
//  SearchProductCell.swift
//  Beer Connect
//
//  Created by Synsoft on 06/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class SearchProductCell: UITableViewCell {

   @IBOutlet weak var lblProductTitle: UILabel!
   @IBOutlet weak var imgProduct: UIImageView?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
