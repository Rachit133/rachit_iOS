//
//  StaticUtility.swift
//  CVDelight_Partner
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
class StaticUtility{
    
    class func isValidMobileNo(value: String) -> Bool {
        let REGEX = "^[6-9][0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    class func isValidPanNo(panNoStr: String) -> Bool {
        var isVaild: Bool = false
        let REGEX = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
        let panTest = NSPredicate(format: "SELF MATCHES %@", REGEX)
        isVaild = panTest.evaluate(with: panNoStr)
        return isVaild
    }

    class func isValidPassword(passwordStr: String) -> Bool {
       let REGEX = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
      let phoneTest = NSPredicate(format: "SELF MATCHES %@", REGEX)
      let result =  phoneTest.evaluate(with: passwordStr)
      return result
    }
    
    // MARK: Check email Validation
    class func isValidUserNameEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,32}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        if valid {
            valid = !email.contains("Invalid email id")
        }
        return valid
    }
    
    class func hideNumberWithAsterisk(phoneNumber: String) -> String {
           do {
            let REGEX = "[0-9]"
            let regex = try NSRegularExpression(pattern: REGEX, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, 6)
            let modString = regex.stringByReplacingMatches(in: phoneNumber,
                                                           options: [],
                                                           range: range,
                                                           withTemplate: "*")
            print(modString)
            return modString
           } catch { return "" }
    }
    
    // MARK: Convert Dictionary into Json String
   class func dictionaryToJsonString(dictionary: [String: Any]) -> String? {
        var jsonString: String? = ""
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString
    }
    
    // MARK: Convert String into Dictionary
   class func jsonStringToDictionary(jsonString: String) -> [String: Any] {
      var jsonDict = [String: Any].init()
        if let data = jsonString.data(using: .utf8) {
            do {
               jsonDict = (try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])!
                return jsonDict
            } catch let error as NSError {
                print(error.description)
            }
        }
        return jsonDict
    }
    
    // MARK: Get System OS Version
    class func getOSVersion() -> String {
        let osVersion = UIDevice.current.systemVersion
        return osVersion
    }
    
    // MARK: Get Application Version
    class func getAppVersion() -> String {
      let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1"
        return appVersion
    }
    
    // MARK: Get Build Version
    class func getBuildVersion() -> Int {
      let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0.0"
        let versionCode = Int(buildVersion)
        return versionCode!
    }
 
    // MARK: Get Application Name
    class func getAppName() -> String {
      let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String ?? ""
        return appName
    }
    
    // MARK: Get Current time zone
    class func getCurrentTimeZone() -> String {
        return String(TimeZone.current.identifier)
    }
    
    // MARK: Get App Bundle Identifier
    class func getBundleIdentifier() -> String {
        let bundleId = Bundle.main.bundleIdentifier
        return bundleId!
    }
    
    // MARK: Get UDID String
    class func getInstallationId() -> String {
        let uuid = NSUUID().uuidString
        return uuid
    }
    
    // MARK: Get Device Modal
    class func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { model, element in
            guard let value = element.value as? Int8, value != 0 else { return model }
            return model + String(UnicodeScalar(UInt8(value)))
        }
        return model
    }
    
    // MARK: Get Device Id
    class func getDeviceId() -> String {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        return uuid ?? UUID().uuidString
    }

   // MARK: - Logs all available fonts from iOS SDK and installed custom font
   class func logAllAvailableFonts() {
       for family in UIFont.familyNames { print("\(family)")
        for name in UIFont.fontNames(forFamilyName: family) { print("   \(name)") }
       }
    }
}
