//
//  AddToCartResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 20/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - SubcatResponse
struct AddToCartResponse: Codable {
   var cartID: CartID?
  
   enum CodingKeys: String, CodingKey {
      case cartID = "cart_id"
   }
   
   init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cartID = try container.decodeIfPresent(CartID.self, forKey: .cartID)
     }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cartID, forKey: .cartID)
     }
   
      init() { }
}

// MARK: - CartID
struct CartID: Codable {
   
    var success: Bool?
    var message: String?
    var itemCount: Int?
    var cartId: String?
   
   enum CodingKeys: String, CodingKey {
      case success = "success"
      case message = "message"
      case itemCount = "items_count"
      case cartId = "cart_id"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      success = try container.decodeIfPresent(Bool.self, forKey: .success)
      message = try container.decodeIfPresent(String.self, forKey: .message)
      itemCount = try container.decodeIfPresent(Int.self, forKey: .itemCount)
      cartId = try container.decodeIfPresent(String.self, forKey: .cartId)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(success, forKey: .success)
      try container.encode(message, forKey: .message)
      try container.encode(itemCount, forKey: .itemCount)
      try container.encode(cartId, forKey: .cartId)
   }
   
   init(){}
}

extension AddToCartResponse {
   func getAddToCartResponseFrom(repsonseData: Data) -> AddToCartResponse? {
     
      do {
            let responseModel = try? JSONDecoder().decode(AddToCartResponse.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return AddToCartResponse.init()
   }
}
