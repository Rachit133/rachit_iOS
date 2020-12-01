//
//  ProductDetailProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 18/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol ProductDetailProtocol: class {
   @objc func onRecievedProductDetailSuccess()
   @objc func onFailure(errorMsg: String)
}

@objc protocol AddCartQuantityProtocol: class {
   @objc func setQuantity(qty: Int)
   @objc func onDissmissCurrentView()
}

@objc protocol AddToCartProtocol: class {
   @objc func onAddCartProductSuccess()
   @objc func onAddToCartFailure(errorMsg: String)
}

