//
//  UIView+Extension.swift
//  CVDelight_Partner
//
//  Created by apple on 28/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

enum LINEPOSITION {
   case LINEPOSITIONTOP
   case LINEPOSITIONBOTTOM
}

extension UIView {
   
   func addLine(position: LINEPOSITION, color: UIColor, width: Double) {
      let lineView = UIView()
      lineView.backgroundColor = color
      lineView.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview(lineView)
      
      let metrics = ["width": NSNumber(value: width)]
      let views = ["lineView": lineView]
      self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:
         "H:|[lineView]|",
                                                         options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                         metrics: metrics,
                                                         views: views))
      
      switch position {
      case .LINEPOSITIONTOP:
         self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]",
         options: NSLayoutConstraint.FormatOptions(rawValue: 0),
         metrics: metrics,
         views: views))
         
      case .LINEPOSITIONBOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                               metrics:metrics,
                                                               views: views))
      }
   }
   
   func setBorderWithShadow() {
      self.layer.cornerRadius = 5
      self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
      self.layer.shadowOffset = CGSize(width: -1, height: -1)
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius  =  2.0
      self.layer.masksToBounds = false
   }
   
   func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
      if #available(iOS 11.0, *) {
         self.layer.maskedCorners = corners
      } else {
         // Fallback on earlier versions
         self.clipsToBounds = true
         let path = UIBezierPath(roundedRect: self.bounds,
                                 byRoundingCorners: [.topRight, .bottomRight],
                                 cornerRadii: CGSize(width: radius, height: radius))
         let maskLayer = CAShapeLayer()
         maskLayer.path = path.cgPath
         self.layer.mask = maskLayer
      }
      
      self.layer.cornerRadius = radius
      self.layer.borderWidth = borderWidth
      self.layer.borderColor = borderColor.cgColor
      
   }
   
   public class func fromNib() -> Self {
      return fromNib(nibName: nil)
   }
   
   public class func fromNib(nibName: String?) -> Self {
      func fromNibHelper<T>(nibName: String?) -> T where T: UIView {
         let bundle = Bundle(for: T.self)
         let name = nibName ?? String(describing: T.self)
         return bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T ?? T()
      }
      return fromNibHelper(nibName: nibName)
   }
}

@IBDesignable extension UIView {
   
   /* BORDER */
   @IBInspectable var borderColor: UIColor? {
      set {
         layer.borderColor = newValue!.cgColor
      }
      get {
         if let color = layer.borderColor {
            return UIColor(cgColor: color)
         } else {
            return nil
         }
      }
   }
   @IBInspectable var borderWidth: CGFloat {
      set {
         layer.borderWidth = newValue
      }
      get {
         return layer.borderWidth
      }
   }
   
   /* BORDER RADIUS */
   @IBInspectable var cornerRadius: CGFloat {
      set {
         layer.cornerRadius = newValue
         clipsToBounds = newValue > 0
      }
      get {
         return layer.cornerRadius
      }
   }
   
   /* SHADOW */
   @IBInspectable var shadowColor: UIColor? {
      set {
         layer.shadowColor = newValue!.cgColor
      }
      get {
         if let color = layer.shadowColor {
            return UIColor(cgColor: color)
         } else {
            return nil
         }
      }
   }
   @IBInspectable var shadowOpacity: Float {
      set {
         layer.shadowOpacity = newValue
      }
      get {
         return layer.shadowOpacity
      }
   }
   @IBInspectable var shadowOffset: CGSize {
      set {
         layer.shadowOffset = newValue
      }
      get {
         return layer.shadowOffset
      }
   }
   @IBInspectable var shadowRadius: CGFloat {
      set {
         layer.shadowRadius = newValue
      }
      get {
         return layer.shadowRadius
      }
   }
}

extension UISegmentedControl{
func setSelectedSegmentColor(with foregroundColor: UIColor, and tintColor: UIColor) {
    if #available(iOS 13.0, *) {
    self.setTitleTextAttributes([.foregroundColor: foregroundColor], for: .selected)
    self.selectedSegmentTintColor = UIColor.black;
    } else {
    self.tintColor = UIColor.black;
    }
   }
   
}
