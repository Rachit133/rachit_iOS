//
//  TransactionHistoryCell.swift
//  CVDelight_Partner
//
//  Created by apple on 28/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TransactionHistoryCell: UITableViewCell {
    
    @IBOutlet weak var separatorLabel: UIView!
    
    @IBOutlet weak var transactionHistoryLabel: UILabel!
    @IBOutlet weak var backgraundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShadow()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

//MARK: Populate Components
extension TransactionHistoryCell{
    
    func setCellUI(){
        transactionHistoryLabel.isHidden = true
    }
    
    func setShadow(){
        // backgraundView.setBorderWithShadow()
    }
    
    func setTopViewCorner(){
        if #available(iOS 11.0, *) {
            self.backgraundView.layer.cornerRadius = 5
            self.backgraundView.layer.masksToBounds = true
            backgraundView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    
    func setBottomViewCorner(){
        if #available(iOS 11.0, *) {
            self.backgraundView.layer.cornerRadius = 5
            self.backgraundView.layer.masksToBounds = true
            backgraundView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        }
        separatorLabel.backgroundColor = .white
    }
}
