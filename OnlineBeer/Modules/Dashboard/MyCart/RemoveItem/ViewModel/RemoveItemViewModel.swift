//
//  UpdateViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit


class RemoveItemViewModel {
   
   weak var delegate: RemoveItemProtocol?
   var removeItemRequest = RemoveItemRequest()
   var removeItemResponse: RemoveItemResponse?
   var successMsg: String? = ""
   
   var cartCountRequest = CartCountRequest.init()
   var cartCountResponse: CartCountResponse?
   
   init(delegate: RemoveItemProtocol) { self.delegate = delegate }
}

// MARK: REMOVE ITEM FROM SERVER
extension RemoveItemViewModel {
   
   func removeItemFromServer() {
      removeItemResponse = RemoveItemResponse.init()
      NetworkManager.shared.makeRequestToServer(for: REMOVEITEM,
                                                method: .POST,
                                                params: self.removeItemRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (removeItemData) in
                                                   
                                                   if removeItemData != nil {
                                                      
                                                      self.removeItemResponse = self.removeItemResponse?.removeItemFrom(repsonseData: removeItemData ?? Data.init())
                                                         self.successMsg = self.removeItemResponse?.cartId?.message

                                                      
                                                      self.delegate?.onReceivedRemoveItemSuccess()
                                                   } else {
                                                      
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
   //                     self.delegate?.onReceivedRemoveItemSuccess(countValue: cartCount)
   //                  } else {
   //                     self.delegate?.onRemoveItemFailure(errorMsg: "There might be error from server side")
   //                  }
   //               }
   //            } else {
   //               self.delegate?.onRemoveItemFailure(errorMsg: "There might be error from server side")
   //            }
   //         }, completionFailure: { (errorObj) in
   //            self.delegate?.onRemoveItemFailure(errorMsg: errorObj.msg ?? "There might be error from server side")
   //         })
   //   }
}
