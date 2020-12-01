//
//  MyCartViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 24/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit


class MyCartViewModel {
   
   weak var delegate: MyCartProtocol?
   var viewCartRequest = ViewCartRequest()
   var viewCartResponse: ViewCartResponse?
   
   var cartCountRequest = CartCountRequest.init()
   var cartCountResponse: CartCountResponse?
   var count: Int? = 0
   var arrMyCartProducts: [CartProduct]?
   
   init(delegate: MyCartProtocol) { self.delegate = delegate }
}

// MARK: GET MY CART PRODUCTS FROM SERVER
extension MyCartViewModel {
   
   func getMyCartProductFromServer() {
      viewCartResponse = ViewCartResponse.init()
      
      NetworkManager.shared.makeRequestToServer(for: VIEWCART,
                                                method: .POST,
                                                params: self.viewCartRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (viewCartData) in
                                                   
                                                   if viewCartData != nil {
                                                      self.viewCartResponse = self.viewCartResponse?.getMyCartDetailsFrom(repsonseData: viewCartData ?? Data.init())
                                                      
                                                      if self.viewCartResponse != nil {
                                                         
                                                         self.arrMyCartProducts = self.viewCartResponse?.data?.products
                                                         //self.getCartCountStatus()
                                                      self.delegate?.onReceivedMyCartSuccess()
                                                      } else {
                                                         self.delegate?.onFailure(errorMsg: "There might be error from server side")
                                                      } } else {
                                                      self.delegate?.onFailure(errorMsg: "There might be error from server side")
                                                   }
      }) {(errorObj) in
         self.delegate?.onFailure(errorMsg: errorObj.localizedDescription)
         print("Failure Response is \(errorObj.localizedDescription)")
      }
   }
   
   func getCartCountStatus() {
         cartCountResponse = CartCountResponse()
         NetworkManager.shared.makeRequestToServer(for: CARTCOUNT,
                                                      method: .POST,
                                                      params: self.cartCountRequest.dictionary,
                                                      isActivityShow: false,
                                                      completionSuccess: { (cartCountData) in
            if cartCountData != nil {
               self.cartCountResponse = self.cartCountResponse?.getCartCountResponse(repsonseData: cartCountData ?? Data.init())
               
               if self.cartCountResponse != nil {
                  if let cartCount: Int = self.cartCountResponse?.data?.itemsCount {
                     self.delegate?.getCartCountStatus(count: cartCount)
                  } else {
                     self.delegate?.onFailure(errorMsg: "There might be error from server side")
                  }
               }
            } else {
               self.delegate?.onFailure(errorMsg: "There might be error from server side")
            }
         }, completionFailure: { (errorObj) in
            self.delegate?.onFailure(errorMsg: errorObj.msg ?? "There might be error from server side")
         })
   }
}

// MARK: Manage Dashboard Response Details
extension MyCartViewModel {
   func saveMyCartDetailsFrom(dashboardDetails: LoginResponse) {
      //UserDefaults.standard.set(true, forKey: "login")
      //UserDefaults.standard.save(customObject: loginDetails, inKey: "loginUser")
   }
}
