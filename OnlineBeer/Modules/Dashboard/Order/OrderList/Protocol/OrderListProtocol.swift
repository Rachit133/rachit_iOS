//
//  OrderListProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol OrderListProtocol: class {
   @objc func onReceivedOrderListSuccess()
   @objc func onFailure(errorMsg: String)
}
