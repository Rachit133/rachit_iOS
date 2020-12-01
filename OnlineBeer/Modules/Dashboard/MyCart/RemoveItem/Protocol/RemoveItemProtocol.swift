//
//  UpdateProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: REMOVE ITEM PROTOCOL
@objc protocol RemoveItemProtocol: class {
   @objc func onReceivedRemoveItemSuccess()
   @objc func onRemoveItemFailure(errorMsg: String)
}
