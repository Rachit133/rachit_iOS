//
//  ProcessCheckOutProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 05/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol ProcessCheckOutProtocol: class {
   @objc func onProcessCheckOutSuccess()
   @objc func onCartCountSuccess(cartCount: Int)
    @objc func onProcessCheckOutFailure(errorMsg: String, code: String)
}
