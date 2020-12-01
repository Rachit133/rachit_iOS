//
//  String+Extension.swift
//  CVDelight_Partner
//
//  Created by Apple on 24/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation.NSString
import UIKit.UIFont
extension String {
    func safelyLimitedTo(length: Int) -> String {
        if self.count <= length {
            return self
        }
        return String( Array(self).prefix(upTo: length) )
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func strikeThrough() -> NSAttributedString {
          let attributeString =  NSMutableAttributedString(string: self)
          attributeString.addAttribute(
              NSAttributedString.Key.strikethroughStyle,
                 value: NSUnderlineStyle.single.rawValue,
                     range:NSMakeRange(0,attributeString.length))
          return attributeString
      }
    
    var stripped: String {
    let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
    return self.filter {okayChars.contains($0) }
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
   
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var isValidName: Bool {
        guard self.count >= 3 else {
            return false
        }
        let regex = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //right is the first encountered string after left
       func between(_ left: String, _ right: String) -> String? {
           guard
               let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
               , leftRange.upperBound <= rightRange.lowerBound
               else { return nil }

           let sub = self[leftRange.upperBound...]
           let closestToLeftRange = sub.range(of: right)!
           return String(sub[..<closestToLeftRange.lowerBound])
       }

       var length: Int {
           get {
               return self.count
           }
       }

       func substring(to : Int) -> String {
           let toIndex = self.index(self.startIndex, offsetBy: to)
           return String(self[...toIndex])
       }

       func substring(from : Int) -> String {
           let fromIndex = self.index(self.startIndex, offsetBy: from)
           return String(self[fromIndex...])
       }

       func substring(_ r: Range<Int>) -> String {
           let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
           let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
           let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
           return String(self[indexRange])
       }

       func character(_ at: Int) -> Character {
           return self[self.index(self.startIndex, offsetBy: at)]
       }

       func lastIndexOfCharacter(_ c: Character) -> Int? {
           return range(of: String(c), options: .backwards)?.lowerBound.encodedOffset
       }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Bold", size: 12)!]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        return self
    }
}
