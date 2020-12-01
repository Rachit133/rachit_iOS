//
//  SortViewCell.swift
//  Beer Connect
//
//  Created by Synsoft on 13/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class SortViewCell: UITableViewCell {

   @IBOutlet weak var radioImage: UIImageView!
   @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
