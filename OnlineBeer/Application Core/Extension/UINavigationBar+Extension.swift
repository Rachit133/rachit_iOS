//
//  UINavigationBar+Extension.swift
//  Beer Connect
//
//  Created by Synsoft on 24/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit
extension UINavigationBar {
    func transparentNavigationBar() {
    self.setBackgroundImage(UIImage(), for: .default)
    self.shadowImage = UIImage()
    self.isTranslucent = true
    }
}
