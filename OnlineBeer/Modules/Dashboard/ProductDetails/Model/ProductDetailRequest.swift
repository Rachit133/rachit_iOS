//
//  ProductDetailRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 18/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct ProductDetailRequest: Codable {
   var productId: String?
   var userId: String?
   var customerId: String?
   
   enum CodingKeys: String, CodingKey {
      case productId = "product-id"
      case customerId = "customer_id"
      case userId = "user-id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["product-id"] = self.productId
      userDict["customer_id"] = self.customerId
      userDict["user-id"] = self.userId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      productId = try values.decodeIfPresent(String.self, forKey: .productId)
      customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
      userId = try values.decodeIfPresent(String.self, forKey: .userId)
   }
   
}
