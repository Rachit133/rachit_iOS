//
//  SaveTokenResponse.swift
//  Beer Connect
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct SaveTokenResponse : Codable {
   var data : TokenData?
   var message : String?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(TokenData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
     
    init() {}
    
}

struct TokenData : Codable {
   var device_token : String?
   var type : String?
   var status : String?
   var message : String?

    enum CodingKeys: String, CodingKey {

        case device_token = "device_token"
        case type = "type"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

    init() {}
}

extension SaveTokenResponse {
   func saveTokenFromServer(repsonseData: Data) -> SaveTokenResponse? {
      do {
         let responseModel = try? JSONDecoder().decode(SaveTokenResponse?.self,
                                                       from: repsonseData)
         if responseModel != nil {
            print("Response Modal is \(String(describing: responseModel))")
            return responseModel
         }
      }
      return SaveTokenResponse.init()
   }
}

struct RemoveTokenResponse: Codable {
    var removeTokenData: RemoveTokenData?
    var message : String?

    enum CodingKeys: String, CodingKey {
        case removeTokenData = "data"
        case message = "message"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        removeTokenData = try values.decodeIfPresent(RemoveTokenData.self, forKey: .removeTokenData)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

    init(){}
}

struct RemoveTokenData: Codable {
   var device_token : String?
   var type : String?
   var status : String?
   var message : String?

    enum CodingKeys: String, CodingKey {
        case device_token = "device_token"
        case type = "type"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

    init() {}
}

extension RemoveTokenResponse {
   func removeTokenFromServer(repsonseData: Data) -> RemoveTokenResponse? {
      do {
         let responseModel = try? JSONDecoder().decode(RemoveTokenResponse?.self,
                                                       from: repsonseData)
         if responseModel != nil {
            print("Response Modal is \(String(describing: responseModel))")
            return responseModel
         }
      }
      return RemoveTokenResponse.init()
   }
}
