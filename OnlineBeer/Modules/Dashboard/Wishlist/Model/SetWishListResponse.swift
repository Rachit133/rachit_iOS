//
//  SetWishListResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 22/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

class SetWishListResponse: Codable {
   var status: String?
   var message: String?
   
   enum CodingKeys: String, CodingKey {
      case status = "status"
      case message = "message"
   }
   
   required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      status = try container.decodeIfPresent(String.self, forKey: .status)
      message = try container.decodeIfPresent(String.self, forKey: .message)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
       var container = encoder.container(keyedBy: CodingKeys.self)
       try container.encode(status, forKey: .status)
       try container.encode(message, forKey: .message)
   }
   
   init() {}
}

extension SetWishListResponse {
   func getWishlistResponse(repsonseData: Data) -> SetWishListResponse? {
      do {
            let responseModel = try? JSONDecoder().decode(SetWishListResponse.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return SetWishListResponse.init()
   }
}
