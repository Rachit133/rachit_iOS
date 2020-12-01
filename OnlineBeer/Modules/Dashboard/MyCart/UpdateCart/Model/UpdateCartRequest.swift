//
//  UpdateCartRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 21/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - DeleteCartRequest
struct UpdateCartRequest: Codable {
   var variationId: Int?
   var quantity: Int?
   var customerId: String?
   var productId: Int?

   enum CodingKeys: String, CodingKey {
      case variationId = "variation_id"
      case quantity = "qty"
      case customerId = "customer_id"
      case productId = "product_id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["variation_id"] = self.variationId
      userDict["qty"] = self.quantity
      userDict["customer_id"] = self.customerId
      userDict["product_id"] = self.productId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      variationId = try values.decodeIfPresent(Int.self, forKey: .variationId)
      quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
      customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
      productId = try values.decodeIfPresent(Int.self, forKey: .productId)

   }
}
