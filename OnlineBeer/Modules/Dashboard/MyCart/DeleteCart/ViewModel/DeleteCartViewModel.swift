//
//  DeleteCartViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit


class DeleteCartViewModel {
   
   weak var delegate: DeleteCartProtocol?
   var deleteCartRequest = DeleteCartRequest()
   var deleteCartResponse: DeleteCardResponse?
   var successMsg: String? = ""
   
   var cartCountRequest = CartCountRequest.init()
   var cartCountResponse: CartCountResponse?
   
   init(delegate: DeleteCartProtocol) { self.delegate = delegate }
}

// MARK: Update MY CART PRODUCTS FROM SERVER
extension DeleteCartViewModel {
   
   func deleteCartFromServer() {
      NetworkManager.shared.checkInternetConnectivity()
      deleteCartResponse = DeleteCardResponse.init()
      NetworkManager.shared.makeRequestToServer(for: DELETECART,
                                                method: .POST,
                                                params: self.deleteCartRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (deleteCartData) in
                                                   
                                                   if deleteCartData != nil {
                                                      
                                                      self.deleteCartResponse = self.deleteCartResponse?.deleteCartDetailsFrom(repsonseData: deleteCartData ?? Data.init())
                                                      
                                                      if let deleteCartMsg: String = self.deleteCartResponse?.message {
                                                        if !deleteCartMsg.isEmpty {
                                                            self.successMsg = deleteCartMsg
                                                        }
                                                      }
                                                      self.delegate?.onReceivedDeleteCartSuccess()
                                                   } else {
                                                      self.delegate?.onDeleteCartFailure(errorMsg: "There is error from server side.")
                                                      
                                                   }
      }) {(errorObj) in
         print("Failure Response is \(errorObj.localizedDescription)")
      }
   }
}
