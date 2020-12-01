//
//  UpdateCartResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 21/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - UpdateCartRequest
struct UpdateCartResponse: Codable {
    
   var cartID: CrtId?
   
   enum CodingKeys: String, CodingKey {
        case cartID = "cart_id"
   }
     
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      cartID = try container.decodeIfPresent(CrtId.self, forKey: .cartID)
   }
     
     // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(cartID, forKey: .cartID)
   }
     
   init() { }
}


// MARK: - CartID
struct CrtId: Codable {
   
    var itemsCount: Int?
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
      itemsCount = try container.decodeIfPresent(Int.self, forKey: .itemsCount)
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


// MARK: - ItemsCount
struct ItmsCount: Codable {
    var cartID: String?
   
   enum CodingKeys: String, CodingKey {
        case cartID = "cart_id"
   }
     
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      cartID = try container.decodeIfPresent(String.self, forKey: .cartID)
   }
     
     // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(cartID, forKey: .cartID)
   }
     
   init() { }
}

extension UpdateCartResponse {
   func updateMyCartDetailsFrom(repsonseData: Data) -> UpdateCartResponse? {
      do {
            let responseModel = try? JSONDecoder().decode(UpdateCartResponse?.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return UpdateCartResponse.init()
   }
}

