//
//  UIApplication+Extension.swift
//  Yellow Pages
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Rachit Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? =
        UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
