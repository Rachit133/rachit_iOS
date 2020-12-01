//
//  MPinCell.swift
//  CVDelight_Partner
//
//  Created by apple on 28/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MPinCell: UITableViewCell {
    
    @IBOutlet weak var backgraundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShadow()
    }
    
    func setShadow(){
        backgraundView.setBorderWithShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
}
