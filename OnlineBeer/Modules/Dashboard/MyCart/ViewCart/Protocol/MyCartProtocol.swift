//
//  MyCartProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 24/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: MYCART PROTOCOL
@objc protocol MyCartProtocol: class {
   @objc func onReceivedMyCartSuccess()
   @objc func getCartCountStatus(count: Int)
   @objc func onFailure(errorMsg: String)
}

@objc protocol MyCartDetailProtocol: class {
   @objc func deleteCurrentProduct(cartCell: MyCartDetailCell)
   @objc func getCartDetails(cartCell: MyCartDetailCell)
   @objc func onErrorRecieved(errorMsg: String)
}
