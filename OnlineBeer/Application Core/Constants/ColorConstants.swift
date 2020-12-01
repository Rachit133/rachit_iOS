//
//  ColorConstant.swift
//  CVDelight_Partner
//
//  Created by Apple on 03/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

struct ColorConstants {
    static let BLUECOLOR = hexStringToUIColor(hex: "2667DB")
    static let WHITECOLOR = hexStringToUIColor(hex: "ffffff")
    static let GREENCOLOR = hexStringToUIColor(hex: "6D9E36")
    static let DARKGRAYCOLOR = hexStringToUIColor(hex: "313131")
    static let LIGHTGRAYCOLOR = hexStringToUIColor(hex: "cccccc")
    static let GRAYCOLOR = hexStringToUIColor(hex: "9b9b9b")
    static let REDCOLOR = hexStringToUIColor(hex: "d0021b")
    static let DISABLECOLOR = hexStringToUIColor(hex: "c7d0d8")
    static let DISABLEBGCOLOR = hexStringToUIColor(hex: "f1f4f9")
    static let kCOLORAPPCOLOR = hexStringToUIColor(hex: "0a0a5f")
    static let kCOLORERRORRED = hexStringToUIColor(hex: "f6483e")
    static let kCOLORHEADERTEXT = hexStringToUIColor(hex: "999999")
    static let kCOLORORANGE = hexStringToUIColor(hex: "ff8400")
    static let kCOLORLIGHTGREEN = hexStringToUIColor(hex: "159f00")
    static let kCOLORPURPLE = hexStringToUIColor(hex: "8e30e1")
    static let kCOLORDOVEGREY = hexStringToUIColor(hex: "666666")
    static let kCOLORBOTTONLINECOLOR = hexStringToUIColor(hex: "dfe0e5")
    static let COLORACTIVITYINDICATOR = hexStringToUIColor(hex: "fa7268")
    static let kCOLORTABLEVIEWBACKGROUND = hexStringToUIColor(hex: "fafafa")
    static let kCOLORDASHBOARDTOP = hexStringToUIColor(hex: "002967")
    static let kCOLORDASHBOARDMIDDLE = hexStringToUIColor(hex: "002255")
    
    static let kCOLORTIMELINEUPTODATE = hexStringToUIColor(hex: "002967")
    static let kCOLORTIMELINEDUE = hexStringToUIColor(hex: "fd9f05")
    static let kCOLORTIMELINELAPSED = hexStringToUIColor(hex: "d0021b")
    static let BLACKCOLOR = hexStringToUIColor(hex: "000000")
    
    static let APPBLUECOLOR = hexStringToUIColor(hex: "1b2749")
    static let APPLITEGRAY = hexStringToUIColor(hex: "D2D2D2")
    
   
}

public func hexStringToUIColor (hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if cString.hasPrefix("#") {
        cString.remove(at: cString.startIndex)
    }
    
    if cString.count != 6 {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
