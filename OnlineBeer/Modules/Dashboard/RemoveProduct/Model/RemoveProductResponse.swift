//
//  RemoveProductResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 20/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - RemoveProductResponse
struct RemoveProductResponse: Codable {
   var cartID: CartId?
   
   enum CodingKeys: String, CodingKey {
          case cartID = "cart_id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["cart_id"] = self.cartID
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      cartID = try values.decodeIfPresent(CartId.self, forKey: .cartID)
   }
   
       // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(cartID, forKey: .cartID)
   }
}

// MARK: - CartID
struct CartId: Codable {
   
    var itemsCount: [String]?
    var itemsCountStatus, success: Bool?
    var message, cartID: String?
   
   enum CodingKeys: String, CodingKey {
      case itemsCount = "items_count"
      case itemsCountStatus = "items_count_status"
      case success = "success"
      case message = "message"
      case cartID = "cart_id"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      itemsCount = try container.decodeIfPresent([String].self, forKey: .itemsCount)
      itemsCountStatus = try container.decodeIfPresent(Bool.self, forKey: .itemsCountStatus)
      success = try container.decodeIfPresent(Bool.self, forKey: .success)
      message = try container.decodeIfPresent(String.self, forKey: .message)
      cartID = try container.decodeIfPresent(String.self, forKey: .cartID)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(itemsCount, forKey: .itemsCount)
      try container.encode(itemsCountStatus, forKey: .itemsCountStatus)
      try container.encode(success, forKey: .success)
      try container.encode(message, forKey: .message)
      try container.encode(cartID, forKey: .cartID)
   }
   
   init() { }
}
