//
//  CustomTabBarController.swift
//  CVDelight_Partner
//
//  Created by apple on 28/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
class CustomTabBarController: UITabBarController {
   
   let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
   // MARK: View lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      tabTitleLocalization()
   }
  
   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .default
   }
   
   override func viewWillAppear(_ animated: Bool) {
       tabTitleLocalization()
      tabBarController?.selectedIndex = 1
   }
   override func viewDidAppear(_ animated: Bool) {
      //appDelegate.mainPage?.selectedIndex = 1
   }
   
}

// MARK: Set TabBar Controller
extension CustomTabBarController {
   func tabTitleLocalization(){
       //tabBar.items![0].title = NSLocalizedString("HOME", comment: "")
       //tabBar.items![1].title = NSLocalizedString("SEARCH", comment: "")
       //tabBar.items![2].title = NSLocalizedString("CART", comment: "")
       //tabBar.items![3].title = NSLocalizedString("WISHLIST", comment: "")
       //tabBar.items![4].title = NSLocalizedString("ACCOUNT", comment: "")
   }
}
