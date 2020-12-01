//
//  AddToCartRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 20/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct AddToCartRequest: Codable {
   var productId: String?
   var quantity: String?
   var customerId: String?
   
   enum CodingKeys: String, CodingKey {
      case productId = "product_id"
      case quantity = "qty"
      case customerId = "customer_id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["product_id"] = self.productId
      userDict["qty"] = self.quantity
      userDict["customer_id"] = self.customerId
      return userDict
   }
   
   init() { }
}
