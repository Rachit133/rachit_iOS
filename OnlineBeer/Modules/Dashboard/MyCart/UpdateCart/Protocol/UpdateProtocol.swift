//
//  UpdateProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: UPDATE PROTOCOL
@objc protocol UpdateCartProtocol: class {
   @objc func onReceivedUpdateCartSuccess()
   @objc func onUpdateCartFailure(errorMsg: String)
}
