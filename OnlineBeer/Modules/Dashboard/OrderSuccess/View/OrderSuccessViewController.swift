//
//  OrderSuccessViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 05/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class OrderSuccessViewController: BaseViewController {

   @IBOutlet weak var btnContinueShopping: UIButton!
   @IBOutlet weak var imgOrderSuccess: UIImageView!
  
   let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
      
        UserDefaults.standard.removeObject(forKey: "addedCartValue")
        // Do any additional setup after loading the view.
    }
   
   override func viewWillAppear(_ animated: Bool) {
      //getNotificationEvent()
      self.manageNavigationBar()
   }
   
   func manageNavigationBar() {
      self.navigationController?.navigationBar.isHidden = false
      self.setNavigationLeftBarButton(viewController: self, imageName: "", target: self, selector:  #selector(backMethodAction(_:)))
      self.navigationItem.title = NSLocalizedString("ORDER_SUCCESS_TITLE", comment: "")

      if #available(iOS 11.0, *) {
         self.navigationController?.navigationBar.prefersLargeTitles = true
         self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
         NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
      }
   }
   @objc func backMethodAction(_ sender: UIButton) { }
}

extension OrderSuccessViewController {
   @IBAction func continueShoppingMethodAction(_ sender: UIButton) {
      DispatchQueue.main.async {
         self.clearAllSavedData()
         self.postNotification()
         self.tabBarController?.selectedIndex = 0
         self.navigationController?.popToRootViewController(animated: true)
      }
   }
   
   func clearAllSavedData() {
      UserDefaults.standard.removeObject(forKey: "shippingDetails")
      UserDefaults.standard.removeObject(forKey: "shippingData")
      UserDefaults.standard.synchronize()
   }
   
   func postNotification() {
      NotificationCenter.default.post(name: Notification.Name("Home"), object: nil)
   }
}
