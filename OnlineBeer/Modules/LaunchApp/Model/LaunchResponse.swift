//
//  LaunchResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 06/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct LaunchResponse: Codable {
   var data: LaunchData?
   var status: String?
   
   
   enum CodingKeys: String, CodingKey {
      case data = "data"
      case status = "status"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      data = try container.decodeIfPresent(LaunchData.self, forKey: .data)
      status = try container.decodeIfPresent(String.self, forKey: .status)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(data, forKey: .data)
      try container.encode(status, forKey: .status)
   }
   
   init() { }
}


struct LaunchData: Codable {
   var signUpUrl: String?
   var bgImage: String?
   var logoUrl: String?
   
   enum CodingKeys: String, CodingKey {
      case signUpUrl = "signup_url"
      case bgImage = "bg_img"
      case logoUrl = "logo_url"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      signUpUrl = try container.decodeIfPresent(String.self, forKey: .signUpUrl)
      bgImage = try container.decodeIfPresent(String.self, forKey: .bgImage)
      logoUrl = try container.decodeIfPresent(String.self, forKey: .logoUrl)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(signUpUrl, forKey: .signUpUrl)
      try container.encode(bgImage, forKey: .bgImage)
      try container.encode(logoUrl, forKey: .logoUrl)

   }
   
   init() { }
}

extension LaunchResponse {
   func getLaunchDetailsFrom(repsonseData: Data) -> LaunchResponse? {
      do {
         let responseModel = try? JSONDecoder().decode(LaunchResponse?.self,
                                                       from: repsonseData)
         if responseModel != nil {
            print("Response Modal is \(String(describing: responseModel))")
            return responseModel
         }
      }
      return LaunchResponse.init()
   }
}
