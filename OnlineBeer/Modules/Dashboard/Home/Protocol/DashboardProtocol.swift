//
//  DashboardProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 11/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol DashboardProtocol: class {
   @objc func onRecievedProductsSuccess()
   @objc func onCartCountSuccess(cartCount: Int)
   @objc func onRecievedWishlistResponse()
   @objc func onCartFailure(errorMsg: String)
   @objc optional func onAdminCustomerLoginSuccess()
   @objc func onFailure(errorMsg: String)
}
