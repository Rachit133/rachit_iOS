//
//  ProcessCheckOutViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 05/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProcessCheckOutViewModel {
   
   weak var delegate: ProcessCheckOutProtocol?
   var processCheckOutRequest = ProcessCheckOutRequest()
   var processCheckOutResponse: ProcessCheckOutResponse?
   
   var cartCountRequest = CartCountRequest.init()
   var cartCountResponse: CartCountResponse?
   var count: Int? = 0
   var arrMyCartProducts: [CartProduct]?
   var isOrderSuccess: Bool = false
   init(delegate: ProcessCheckOutProtocol) { self.delegate = delegate }
}

// MARK: Proceed To Check Out
extension ProcessCheckOutViewModel {
   
   func processCheckOutToServer() {
      processCheckOutResponse =  ProcessCheckOutResponse.init()
      
      NetworkManager.shared.makeRequestToServer(for: PROCESSCHECKOUT,
                                                method: .POST,
                                                params: self.processCheckOutRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (processCheckOutData) in
                                                   
                                                   if processCheckOutData != nil {
                                                      self.processCheckOutResponse = self.processCheckOutResponse?.processCheck(repsonseData: processCheckOutData ?? Data.init())
                                                      
                                                      if self.processCheckOutResponse != nil {
                                                        
                                                         if let isSuccess = self.processCheckOutResponse?.success {
                                                            self.isOrderSuccess = isSuccess
                                                            if self.isOrderSuccess {
                                                              self.delegate?.onProcessCheckOutSuccess()

                                                            }
                                                         } else {
                                                            self.delegate?.onProcessCheckOutFailure(errorMsg: self.processCheckOutResponse?.message ?? "", code: "product out of stock error")
                                                        }
                                                      } else {
                                                         self.delegate?.onProcessCheckOutFailure(errorMsg: "There might be error from server side", code: "")
                                                      }
                                                   }
                                                   else {
                                                      self.delegate?.onProcessCheckOutFailure(errorMsg: "There might be error from server side", code: "")
                                                   }
                                                   
      }) {(errorObj) in
        self.delegate?.onProcessCheckOutFailure(errorMsg: errorObj.localizedDescription, code: "")
         print("Failure Response is \(errorObj.localizedDescription)")
      }
      
   }
   
   func getCartCountStatus() {
         cartCountResponse = CartCountResponse()
         NetworkManager.shared.makeRequestToServer(for: CARTCOUNT,
                                                      method: .POST,
                                                      params: self.cartCountRequest.dictionary,
                                                      isActivityShow: true,
                                                      completionSuccess: { (cartCountData) in
            if cartCountData != nil {
               self.cartCountResponse = self.cartCountResponse?.getCartCountResponse(repsonseData: cartCountData ?? Data.init())
               guard let itemCount: Int = self.cartCountResponse?.data?.itemsCount else { self.delegate?.onCartCountSuccess(cartCount: 0)
                  return
               }

               if self.cartCountResponse != nil {
                     self.delegate?.onCartCountSuccess(cartCount: itemCount)
               }
            } else {
                self.delegate?.onProcessCheckOutFailure(errorMsg: "There might be error from server side", code: "")
            }
         }, completionFailure: { (errorObj) in
            self.delegate?.onProcessCheckOutFailure(errorMsg: errorObj.msg ?? "There might be error from server side", code: "")
         })
   }
}
