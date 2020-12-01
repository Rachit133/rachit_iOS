//
//  AddToCartPopUp.swift
//  Beer Connect
//
//  Created by Synsoft on 24/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class AddToCartPopUpViewController: BaseViewController {
   @IBOutlet weak var addToCartPopUpView: UIView!
   @IBOutlet weak var addCartPicker: UIPickerView!
   @IBOutlet weak var lblTitle: UILabel!
   @IBOutlet weak var btnAddToCart: UIButton!
 
   var arrCartQuantity = [Int].init() //["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
   weak var delegate: AddCartQuantityProtocol?
   var selectedVal: Int? = 1
   var productQuantity: Int = 1
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
      view?.backgroundColor = UIColor(red: 19.0 / 255.0, green: 27.0 / 255.0, blue: 52.0 / 255.0, alpha: 0.5)
      initComponents()
   }

   @IBAction func closeCurrentVCMethodAction(_ sender: Any) {
      self.delegate?.onDissmissCurrentView()
      UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
   }
}

extension AddToCartPopUpViewController {
   
   func initComponents() {
      populateStockQuantity()
      populateAddToCartUI()
   }
   
   func populateStockQuantity() {
      for number in (1...productQuantity) {
         self.arrCartQuantity.append(number)
      }
   }
   
   func populateAddToCartUI() {
      self.lblTitle.text = NSLocalizedString("QUANTITY_TITLE", comment: "")
   }
   
}

extension AddToCartPopUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView,
                   numberOfRowsInComponent component: Int) -> Int {
      return arrCartQuantity.count
   }
   
   func pickerView(_ pickerView: UIPickerView,
                   titleForRow row: Int,
                   forComponent component: Int) -> String? {
      let row  = arrCartQuantity[row].description
      return row
   }
   
   func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      return 60.0
   }
   func pickerView(_ pickerView: UIPickerView,
                   didSelectRow row: Int,
                   inComponent component: Int) {
      //print("Select Row is \(arrCartQuantity[row])")
      if self.delegate != nil {
         self.selectedVal = arrCartQuantity[row]
      }
   }
}

extension AddToCartPopUpViewController {
   @IBAction func addToCartMethodAction(_ sender: Any) {
      self.delegate?.setQuantity(qty: self.selectedVal ?? 1)
   UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
      // self.dismiss(animated: true, completion: nil)
   }
}
