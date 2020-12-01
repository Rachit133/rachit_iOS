//
//  SettingViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 23/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

   let appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         manageNavigationUI()
    }
   
   override func viewWillAppear(_ animated: Bool) {}
   
   override func viewDidAppear(_ animated: Bool) {
       DispatchQueue.main.async {
              self.view.makeToast("Coming Soon", duration: 1.5, position: .center)
           }
   }
}

extension SettingViewController {
   func manageNavigationUI(){
      self.appDelegate?.navigationController?.navigationBar.isHidden = true
      self.navigationController?.navigationBar.isHidden = false
        BaseViewController.showHideRootNavigationBar(isVisible: false)
        self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
        //self.tabBarController?.tabBar.isHidden = true
         if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
            NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
         }
     }
   
   @objc func backMethodAction(_ sender: UIButton) {
      self.tabBarController?.selectedIndex = 0
      self.navigationController?.popViewController(animated: true)
   }
   
}
