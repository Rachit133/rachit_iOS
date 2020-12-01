//
//  UIViewController+Extension.swift
//  CVDelight_Partner
//
//  Created by Apple on 03/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit.UIViewController
extension UIViewController {
   
   func showSideBarMenu(mainVC : UIViewController){
        
        /*
        
        var basketTopFrame = mainVC.view.frame
        basketTopFrame.origin.x = 115
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            mainVC.view.frame = basketTopFrame
        }) { finished in
        }*/
        
    }
   
   func showInputDialog(title:String? = nil,
                        subtitle:String? = nil,
                        actionTitle:String? = "Add",
                        cancelTitle:String? = "Cancel",
                        inputPlaceholder:String? = nil,
                        inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                        cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                        actionHandler: ((_ text: String?) -> Void)? = nil) {

       let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
       alert.addTextField { (textField:UITextField) in
           textField.placeholder = inputPlaceholder
           textField.keyboardType = inputKeyboardType
       }
       alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
           guard let textField =  alert.textFields?.first else {
               actionHandler?(nil)
               return
           }
           actionHandler?(textField.text)
       }))
       alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

       self.present(alert, animated: true, completion: nil)
   }
   
}
