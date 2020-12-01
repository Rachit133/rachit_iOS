//
//  OrderReviewViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 02/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderReviewViewModel {
   
   weak var delegate: OrderReviewProtocol?
   var orderReviewRequest = OrderReviewRequest()
   var orderReviewResponse: OrderReviewResponse?
   
   var cartCountRequest = CartCountRequest.init()
   var cartCountResponse: CartCountResponse?
   var count: Int? = 0
   var arrMyCartProducts: [CartProduct]?
   var arrGateWay: [Gateway]?
    
   init(delegate: OrderReviewProtocol) { self.delegate = delegate }
}

// MARK: Proceed To Check Out
extension OrderReviewViewModel {
   
   func proceedToCheckOutToServer() {
      orderReviewResponse =  OrderReviewResponse.init()
      
      NetworkManager.shared.makeRequestToServer(for: ORDERCHECKOUT,
                                                method: .POST,
                                                params: self.orderReviewRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (orderReviewCartData) in

          if orderReviewCartData != nil {
             self.orderReviewResponse = self.orderReviewResponse?.getCheckDetails(repsonseData: orderReviewCartData ?? Data.init())
             
             if self.orderReviewResponse != nil {
               if let statusFlag: Bool = self.orderReviewResponse?.success {
                  if statusFlag == true {
                     if self.orderReviewResponse?.data?.products?.count ?? 0 > 0 {
                        self.arrMyCartProducts = self.orderReviewResponse?.data?.products
                     }
                     self.delegate?.onOrderReviewSuccess()
                  } else {
                     self.delegate?.onOrderReviewFailure(errorMsg: "There might be error from server side")
                  }
                }
                
                if let outOfStock = self.orderReviewResponse?.code {
                    if outOfStock.lowercased().trim().contains("out of stock error") {
                        if let message = self.orderReviewResponse?.message {
                            self.delegate?.onOrderReviewFailure(errorMsg: message)
                        }
                    }
                }
            }
          } else {
            self.delegate?.onOrderReviewFailure(errorMsg: "There might be error from server side")
         }
                                                   
      }) {(errorObj) in
         self.delegate?.onOrderReviewFailure(errorMsg: errorObj.localizedDescription)
         print("Failure Response is \(errorObj.localizedDescription)")
      }
   }
}

