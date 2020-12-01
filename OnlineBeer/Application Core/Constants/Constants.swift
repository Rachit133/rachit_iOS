//
//  Constants.swift
//  CVDelight_Partner
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

class Constants{
    
    //Login Constants
    static let LOGIN = "Login"
    static let APPNAME = ""
    
    static let ENGLANG = "en"
    static let HINLANG = "hi"
        
    //OTP Keys constants
    static let OTPKEY = "1000"
    static let SPLASH = "splash"
    
    //RC Status
    static let RCPENDING = "Pending"
    //static let RC_REQUESTED = "requested"
    static let RCCOMPLETED = "Completed"
    static let RCFAILED = "Failure"
    static let RCUPLOAD = ""
    
    //is primary contact ID
    
    static var ISSEARCHCONTACT = false
    
    //status of ARN/CRN
    static let ACTIVE = "Active"
    static let EXPIRED = "expired"
    static let DEACTIVE = "de-active"
    //static let DEACTIVE = "deactive"
    static let RNINPROCESS = "rn in-process"
    static let INPROCESS = "inprocess"
    static let ONHOLD = "on hold"
    static let INACTIVE = "Inactive"
    static let CRNTYPE = "Individual"
    
    /*
    //Response closures
    typealias otpResponseClosure = (OTPResponse)->()
    typealias verifyotpResponseClosure = (VerifyOTPResponse)->()
    typealias loginResponseClosure = (LoginResponse)->()
    typealias mpinGenerationResponseClosure = (MpinResponse)->()
    typealias redeemPointDetailsResponseClosure = (RedeemPointResponse)->()
    //typealias verifyotpResponseClosure = (VerifyOTPResponse)->()
    typealias membershipResponseCLosure = (MembershipResponse)->()
    typealias transctionReponseClosure = (TransactionResponse)->()
    typealias arncrnResponseClosure = (ArnCrnResponse)->()
    typealias enrolmentResponseClosure = (EnrollmentResponse)->()
    typealias createNewMpinResponseClosure = (CreateNewMpinResponse)->()
    typealias vehicleInfoLiteResponseClosure = (VehicleInfoLiteResponse)->()
    typealias linkVehicleeResponseClosure = (LinkVehicleResponse)->()
    typealias activatearncrnResponseClosure = (ActiveARNResponse)->()
    typealias contactResponseClosure = (ContactResponse)->()
    typealias vehicleMemberResponseClosure = (VehicleMeberIDResponse)->()
    typealias vehicleMemberMergeClosure = (MergeResponse)->()
    typealias addVehicleResponseClosure = (AddVehicleResponse)->()
    typealias versionResponseClosure = (AppVersionResponse)->()
    typealias reportIssueResponseClosure = (ReportIssueResponse)->()
    typealias uploadRCResponseClosure = (RCUploadResponse)->()
    typealias refreshTokenResponseClosure = (RefreshTokenResponse)-> ()
    
    
    //failure closures
    typealias failureClosure = (ApiError)->()*/
}

enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case phone
    case pad
}

struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    static let iPhone4OrLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
    static let iPhoneSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
    static let iPhone8 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
    static let iPhone8Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
    static let iPhoneXr = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 896.0
    static let iPhoneXs = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 812.0
    static let iPhoneXsMax = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 896.0
    static let iPad = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 1024.0
}
