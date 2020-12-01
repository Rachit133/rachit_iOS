//
//  LoginProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 21/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

 protocol LoginProtocol: class {
   func onLoginSuccess(response: LoginResponse)
   func onLoginFailure(errorMsg: String)
   func onValidationErrorAlert(title: String, message: String)
}
