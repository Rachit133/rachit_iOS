//
//  WishlistProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 02/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
// MARK: WISHLIST PROTOCOL
@objc protocol FetchWishlistProtocol: class {
   @objc func onReceivedWishlistSuccess()
   @objc func onFailure(errorMsg: String)
}
