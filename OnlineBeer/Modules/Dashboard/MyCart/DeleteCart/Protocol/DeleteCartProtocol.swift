//
//  DeleteCartProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: DELETE PROTOCOL
@objc protocol DeleteCartProtocol: class {
   @objc func onReceivedDeleteCartSuccess()
   @objc func onDeleteCartFailure(errorMsg: String)
}
