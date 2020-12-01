//
//  MyCartDetailCell.swift
//  Beer Connect
//
//  Created by Synsoft on 24/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class MyCartDetailCell: UITableViewCell {

   @IBOutlet weak var titleImage: UIImageView!
   @IBOutlet weak var lblTitle: UILabel!
   @IBOutlet weak var lblPrice: UILabel!
   @IBOutlet weak var lblTotal: UILabel!
   @IBOutlet weak var lblDiscount: UILabel!
   @IBOutlet weak var imgPriceSymbol: UIImageView!
   @IBOutlet weak var backView: UIView!

   @IBOutlet weak var manageQuantityView: UIView!
   @IBOutlet weak var btnAddQuantity: UIButton!
   @IBOutlet weak var btnSubtractQuantity: UIButton!
   @IBOutlet weak var lblQuantityCount: UILabel!
   @IBOutlet weak var btnDeleteProduct: UIButton!
   @IBOutlet weak var viewOutOfStock: UIView!
   @IBOutlet weak var lblOutOfStockMessage: UILabel!

   
   var productId: Int = 0
   weak var delegate: MyCartDetailProtocol?
   var counter = 1
   var maxValue: Int = 10

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

   @IBAction func updateProductMethodAction(_ sender: UIButton) {
      if sender == self.btnAddQuantity {
         // Do Increment Here
         if let countVal = Int(self.lblQuantityCount.text ?? "1") {
            if countVal < 100 {
               self.counter = countVal
               self.counter += 1
               self.lblQuantityCount.text = counter.description
               self.delegate?.getCartDetails(cartCell: self)
            } else {
              //self.lblQuantityCount.text = counter.description
              //self.counter = maxCount
               self.delegate?.onErrorRecieved(errorMsg: "Maximum quantity is \(maxValue).")
              return
            }
            
         }
         
      } else if sender == self.btnSubtractQuantity {
         // Do Decrement Here
         let minCount = 1
         
         if let countVal = Int(self.lblQuantityCount.text ?? "10") {
            self.maxValue = countVal
            if countVal > minCount {
               self.counter = countVal
               self.counter -= 1
               self.lblQuantityCount.text = self.counter.description
               self.delegate?.getCartDetails(cartCell: self)
            } else {
               self.delegate?.onErrorRecieved(errorMsg: "Minimum Quantity \(minCount).")
               //print("Final Value is \(self.counter)")
               return
            }
         }
      }
   }

   @IBAction func removeItemMethodAction(_ sender: UIButton) {
      self.delegate?.deleteCurrentProduct(cartCell: self)
   }
}


