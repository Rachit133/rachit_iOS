//
//  CartCountRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - DeleteCartRequest
struct CartCountRequest: Codable {
   var customerId: String?
   var cartId: String?
   
   enum CodingKeys: String, CodingKey {
      case cartId = "cart_id"
      case customerId = "customer_id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["cart_id"] = self.cartId
      userDict["customer_id"] = self.customerId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      cartId = try values.decodeIfPresent(String.self, forKey: .cartId)
      customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
   }
}
