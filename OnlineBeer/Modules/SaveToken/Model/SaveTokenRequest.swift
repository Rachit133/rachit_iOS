//
//  SaveTokenRequest.swift
//  Beer Connect
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - SAVE TOKEN
struct SaveTokenRequest: Codable {
   var tokenId: String?
   var type: String?
   
   enum CodingKeys: String, CodingKey {
      case tokenId = "token-id"
      case type = "type"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["type"] = self.type
      userDict["token-id"] = self.tokenId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      tokenId = try values.decodeIfPresent(String.self, forKey: .tokenId)
      type = try values.decodeIfPresent(String.self, forKey: .type)
   }
}

// MARK: - REMOVE TOKEN
struct RemoveTokenRequest: Codable {
   var tokenId: String?
   var type: String?
   
   enum CodingKeys: String, CodingKey {
      case tokenId = "token-id"
      case type = "type"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["type"] = self.type
      userDict["token-id"] = self.tokenId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      tokenId = try values.decodeIfPresent(String.self, forKey: .tokenId)
      type = try values.decodeIfPresent(String.self, forKey: .type)
   }
}
