//
//  FontUtility.swift
//  Yellow Pages
//
//  Created by Apple on 23/12/19.
//  Copyright © 2019 Rachit Sharma. All rights reserved.
//
import Foundation
import UIKit

//OpenSans Regular
let openSansRegular10      = Font(.installed(.openSansRegular), size: .standard(.height6)).instance
let openSansRegular12      = Font(.installed(.openSansRegular), size: .standard(.height5)).instance
let openSansRegular14      = Font(.installed(.openSansRegular), size: .standard(.height4)).instance
let openSansRegular16      = Font(.installed(.openSansRegular), size: .standard(.height3)).instance
let openSansRegular18      = Font(.installed(.openSansRegular), size: .standard(.height2)).instance
let openSansRegular20      = Font(.installed(.openSansRegular), size: .standard(.height1)).instance

//OpenSans Light
let openSansLight10        = Font(.installed(.openSansLight), size: .standard(.height6)).instance
let openSansLight12        = Font(.installed(.openSansLight), size: .standard(.height5)).instance
let openSansLight14        = Font(.installed(.openSansLight), size: .standard(.height4)).instance
let openSansLight16        = Font(.installed(.openSansLight), size: .standard(.height3)).instance
let openSansLight18        = Font(.installed(.openSansLight), size: .standard(.height2)).instance
let openSansLight20        = Font(.installed(.openSansLight), size: .standard(.height1)).instance

//OpenSans SemiBold
let openSansSemiBold10     = Font(.installed(.openSansSemiBold), size: .standard(.height6)).instance
let openSansSemiBold12     = Font(.installed(.openSansSemiBold), size: .standard(.height5)).instance
let openSansSemiBold14     = Font(.installed(.openSansSemiBold), size: .standard(.height4)).instance
let openSansSemiBold16     = Font(.installed(.openSansSemiBold), size: .standard(.height3)).instance
let openSansSemiBold18     = Font(.installed(.openSansSemiBold), size: .standard(.height2)).instance
let openSansSemiBold20     = Font(.installed(.openSansSemiBold), size: .standard(.height1)).instance

let openSansBold10      = Font(.installed(.openSansBold), size: .standard(.height6)).instance
let openSansBold12      = Font(.installed(.openSansBold), size: .standard(.height5)).instance
let openSansBold14      = Font(.installed(.openSansBold), size: .standard(.height4)).instance
let openSansBold16      = Font(.installed(.openSansBold), size: .standard(.height3)).instance
let openSansBold18      = Font(.installed(.openSansBold), size: .standard(.height2)).instance
let openSansBold20      = Font(.installed(.openSansBold), size: .standard(.height1)).instance
let openSansBold34      = Font(.installed(.openSansBold), size: .standard(.height34)).instance

struct Font {

    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
        case monoSpacedDigit(size: Double, weight: Double)
    }
    
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    enum FontName: String {
      case openSansLight          = "OpenSans-Light"
      case openSansBold           = "OpenSans-Bold"
      case openSansSemiBold       = "OpenSans-Semibold"
      case openSansRegular        = "OpenSans"
    }
    
    enum StandardSize: Double {
        case height1 = 20.0
        case height2 = 18.0
        case height3 = 16.0
        case height4 = 14.0
        case height5 = 12.0
        case height6 = 10.0
        case height34 = 34.0
    }

    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

extension Font {
    
    var instance: UIFont {
        
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
               fatalError("\(fontName) font is not installed, make sure it added in Info.plist")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
               fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                             weight: UIFont.Weight(rawValue: CGFloat(weight)))
        case .monoSpacedDigit(let size, let weight):
            instanceFont = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size),
                                                            weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}

class FontUtility {
    /// Logs all available fonts from iOS SDK and installed custom font
    class func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}
