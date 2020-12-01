//
//  WishlistViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 02/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation


class WishlistViewModel {
   
   weak var delegate: FetchWishlistProtocol?
   var getWishlistRequest = GetWishlistRequest()
   var getWishlistResponse: GetWishlistResponse?
   var arrWishlistProducts: [Product]?
   
   init(delegate: FetchWishlistProtocol) { self.delegate = delegate }
}

// MARK: GET WISHLIST PRODUCTS FROM SERVER
extension WishlistViewModel {
   
   func getWishlistProductFromServer() {
      getWishlistResponse = GetWishlistResponse.init()
      NetworkManager.shared.makeRequestToServer(for: FETCHWISHLIST,
                                                method: .POST,
                                                params: self.getWishlistRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (getWishlistData) in
                                                   
                                                   if getWishlistData != nil {
                                                      self.getWishlistResponse =
                                                  self.getWishlistResponse?.fetchWishlistProducts(repsonseData: getWishlistData ?? Data.init())
                                                      
                                                      if self.getWishlistResponse != nil {
                                                         
                                                         self.arrWishlistProducts = self.getWishlistResponse?.wishlist
                                                         self.delegate?.onReceivedWishlistSuccess()
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
}
