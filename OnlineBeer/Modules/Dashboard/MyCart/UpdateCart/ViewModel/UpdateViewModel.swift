//
//  UpdateViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit


class UpdateCartViewModel {
   
   weak var delegate: UpdateCartProtocol?
   
   var updateCartRequest = UpdateCartRequest()
   var updateCartResponse: UpdateCartResponse?
   
   var cartCountRequest = CartCountRequest.init()
   var cartCountResponse: CartCountResponse?
   var successMsg: String? = ""
   
   init(delegate: UpdateCartProtocol) { self.delegate = delegate }
}

// MARK: Update MY CART PRODUCTS FROM SERVER
extension UpdateCartViewModel {
   
   func updateCartProductFromServer() {
      NetworkManager.shared.checkInternetConnectivity()
      updateCartResponse = UpdateCartResponse.init()
      NetworkManager.shared.makeRequestToServer(for: UPDATECART,
                                                method: .POST,
                                                params: self.updateCartRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (updateCartData) in
                                                   
                                                   if updateCartData != nil {
                                                      
                                                      self.updateCartResponse = self.updateCartResponse?.updateMyCartDetailsFrom(repsonseData: updateCartData ?? Data.init())
                                                      self.successMsg = self.updateCartResponse?.cartID?.message
                                                       self.delegate?.onReceivedUpdateCartSuccess()
                                                   } else {
                                                      self.delegate?.onUpdateCartFailure(errorMsg: "There might be error from server side")
                                                      
                                                   }
      }) {(errorObj) in
         print("Failure Response is \(errorObj.localizedDescription)")
      }
   }
   
   //   func getCartCountStatus() {
   //         cartCountResponse = CartCountResponse()
   //         NetworkManager.shared.makeRequestToServer(for: CARTCOUNT,
   //                                                      method: .POST,
   //                                                      params: self.cartCountRequest.dictionary,
   //                                                      isActivityShow: true,
   //                                                      completionSuccess: { (cartCountData) in
   //            if cartCountData != nil {
   //               self.cartCountResponse = self.cartCountResponse?.getCartCountResponse(repsonseData: cartCountData ?? Data.init())
   //
   //               if self.cartCountResponse != nil {
   //                  if let cartCount: Int = self.cartCountResponse?.data?.itemsCount {
   //                     self.delegate?.onReceivedUpdateCartSuccess(countValue: cartCount)
   //                  } else {
   //                     self.delegate?.onUpdateCartFailure(errorMsg: "There might be error from server side")
   //                  }
   //               }
   //            } else {
   //               self.delegate?.onUpdateCartFailure(errorMsg: "There might be error from server side")
   //            }
   //         }, completionFailure: { (errorObj) in
   //            self.delegate?.onUpdateCartFailure(errorMsg: errorObj.msg ?? "There might be error from server side")
   //         })
   //   }
}

// MARK: Manage Update Cart Response Details
extension UpdateCartViewModel {
   func updateMyCartDetailsFrom(dashboardDetails: UpdateCartResponse) {
      //UserDefaults.standard.set(true, forKey: "login")
      //UserDefaults.standard.save(customObject: loginDetails, inKey: "loginUser")
   }
}
