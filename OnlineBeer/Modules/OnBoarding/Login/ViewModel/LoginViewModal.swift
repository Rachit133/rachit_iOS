//
//  LoginViewModal.swift
//  Beer Connect
//
//  Created by Synsoft on 21/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

class LoginViewModal {
    
    weak var delegate: LoginProtocol?
    var loginRequest = LoginRequest()
    var loginResponse = LoginResponse()

    init(delegate: LoginProtocol) { self.delegate = delegate }
}

// MARK: LOGIN CALL TO SERVER
extension LoginViewModal {
    func loginSubmitToServer() {
        if isLoginValidate() {
            NetworkManager.shared.makeRequestToServer(for: LOGINURL,
                                                      method: .POST,
                                                      params: self.loginRequest.dictionary,
                                                      isActivityShow: true,
                                                      completionSuccess: { (loginData) in
                
               if loginData != nil {
                  self.loginResponse = self.loginRequest.getLoginDetails(repsonseData: loginData ?? Data.init()) ?? LoginResponse.init()
                  if let status = self.loginResponse.data?.status?.lowercased().trim() {
                     if status.contains("success") {
                        if let isSalesPerson = self.loginResponse.data?.customer?.salePerson {
                            if isSalesPerson {
                                self.saveAdminSalesDetailsFrom(adminSalesDetails: self.loginResponse)
                            } else {                          self.saveLoginDetailsFrom(loginDetails: self.loginResponse)
                            }
                        } else {
                            self.saveLoginDetailsFrom(loginDetails: self.loginResponse)
                        }
                        self.delegate?.onLoginSuccess(response: self.loginResponse)
                     } else {
                        if status.contains("error") || status.contains("exception") || status.isEmpty || status == "" {
                            if let message = self.loginResponse.data?.message {
                                self.delegate?.onLoginFailure(errorMsg: message)
                            }
                        }
                        
                    }
                  }
               }
            }) {(errorObj) in self.delegate?.onLoginFailure(errorMsg: errorObj.msg ?? "") }
        }
    }
    
    func isLoginValidate() -> Bool {
        var isValidate: Bool = true
        var username: String? = ""
        var password: String? = ""
        
        if let userName = self.loginRequest.userEmail { username = userName }
        if let passWord = self.loginRequest.password { password = passWord }

        if username?.isEmpty ?? false {
            isValidate = false
            self.delegate?.onValidationErrorAlert(
                     title: NSLocalizedString("ALERT_ERROR_TITLE", comment: ""),
                     message: NSLocalizedString("ALERT_USERNAME_EMPTY", comment: ""))
        } else if !(username?.isValidEmail(email: username ?? "") ?? false) {
            isValidate = false
            self.delegate?.onValidationErrorAlert(title: NSLocalizedString("ALERT_ERROR_TITLE", comment: ""), message: NSLocalizedString("ALERT_INVALID_EMAIL", comment: ""))
        } else if password?.isEmpty ?? false {
            isValidate = false
            self.delegate?.onValidationErrorAlert(
               title: NSLocalizedString("ALERT_ERROR_TITLE", comment: ""),
               message: NSLocalizedString("ALERT_PASSWORD_EMPTY",
               comment: ""))
        } else if password?.count ?? 0 < 4 {
            isValidate = false
            self.delegate?.onValidationErrorAlert(
               title: NSLocalizedString("ALERT_ERROR_TITLE", comment: ""),
               message: NSLocalizedString("ALERT_INVALID_PASSWORD", comment: ""))
        }
        return isValidate
    }
}

// MARK: Manage Login Response Details
extension LoginViewModal {
   func saveLoginDetailsFrom(loginDetails: LoginResponse) {
      UserDefaults.standard.save(customObject: loginDetails, inKey: "loginUser")
      UserDefaults.standard.set(true, forKey: "login")
   }
    
   func saveAdminSalesDetailsFrom(adminSalesDetails: LoginResponse) {
      UserDefaults.standard.save(customObject: adminSalesDetails, inKey: "adminSalesDetails")
      UserDefaults.standard.set(true, forKey: "adminLogin")
   }
}
