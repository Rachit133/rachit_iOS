//
//  DeleteCartResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

// MARK: - DeleteCardResponse

import Foundation

struct DeleteCardResponse: Codable {
   
   var success: Bool?
   var data: DeleteData?
   var message: String?
   
   enum CodingKeys: String, CodingKey {
      case data = "data"
      case success = "success"
      case message = "message"
      
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      success = try container.decodeIfPresent(Bool.self, forKey: .success)
      data = try container.decodeIfPresent(DeleteData.self, forKey: .data)
      message = try container.decodeIfPresent(String.self, forKey: .message)
      
   }
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(success, forKey: .success)
      try container.encode(data, forKey: .data)
      try container.encode(message, forKey: .message)
   }
   
   init() { }
}

// MARK: - CartID
struct DeleteData: Codable {
   
   var lang: [String]?
   
   enum CodingKeys: String, CodingKey {
      case lang = "lang"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      lang = try container.decodeIfPresent([String].self, forKey: .lang)
   }
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(lang, forKey: .lang)
   }
   
   init() { }
}


extension DeleteCardResponse {
   func deleteCartDetailsFrom(repsonseData: Data) -> DeleteCardResponse? {
      do {
         let responseModel = try? JSONDecoder().decode(DeleteCardResponse?.self,
                                                       from: repsonseData)
         if responseModel != nil {
            print("Response Modal is \(String(describing: responseModel))")
            return responseModel
         }
      }
      return DeleteCardResponse.init()
   }
}
