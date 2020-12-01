//
//  CartCountResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

// MARK: - CartCountResponse

import Foundation

struct CartCountResponse: Codable {
   var data: DataCls?
   var status: Bool?
   
   enum CodingKeys: String, CodingKey {
      case data = "data"
      case status = "status"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      status = try container.decodeIfPresent(Bool.self, forKey: .status)
      data = try container.decodeIfPresent(DataCls.self, forKey: .data)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(status, forKey: .status)
      try container.encode(data, forKey: .data)
   }
   
   init() { }
}


// MARK: - DataClass
struct DataCls: Codable {
   
   var itemsCount: Int? = 0
   var lang: [Lang]?
   
   enum CodingKeys: String, CodingKey {
      case itemsCount = "items_count"
      case lang = "lang"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      itemsCount = try container.decodeIfPresent(Int.self, forKey: .itemsCount)
      lang = try container.decodeIfPresent([Lang].self, forKey: .lang)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(itemsCount, forKey: .itemsCount)
      try container.encode(lang, forKey: .lang)
   }
   
   init() { }
}

// MARK: - Lang
struct Lang: Codable {
   var langId: String?
   
   enum CodingKeys: String, CodingKey {
      case langId = "id"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      langId = try container.decodeIfPresent(String.self, forKey: .langId)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(langId, forKey: .langId)
   }
   
   init() { }
}


extension CartCountResponse {
   func getCartCountResponse(repsonseData: Data) -> CartCountResponse? {
      do {
            let responseModel = try? JSONDecoder().decode(CartCountResponse.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return CartCountResponse.init()
   }
}
