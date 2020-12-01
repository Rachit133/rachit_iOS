//
//  ProcessCheckOutResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 05/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation


// MARK: - ProcessCheckOutResponse
struct ProcessCheckOutResponse: Codable {
    
    var paymentResponse: PaymentResponse?
    var message: String?
    var success: Bool?
   
   enum CodingKeys: String, CodingKey {
      case message = "message"
      case success = "success"
      case paymentResponse = "payment_response"
   }
   
   init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
       message = try container.decodeIfPresent(String.self, forKey: .message)
       paymentResponse = try container.decodeIfPresent(PaymentResponse.self, forKey: .paymentResponse)
     }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encode(paymentResponse, forKey: .paymentResponse)
        try container.encode(message, forKey: .message)
     }
     
     init() { }
}


// MARK: - PaymentResponse
struct PaymentResponse: Codable {
   var result: String?
   var redirect: String?
   
   enum CodingKeys: String, CodingKey {
        case result = "result"
        case redirect = "redirect"
     }
     
     init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          result = try container.decodeIfPresent(String.self, forKey: .result)
         redirect = try container.decodeIfPresent(String.self, forKey: .redirect)
       }
       
       // Encoding
       func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(result, forKey: .result)
          try container.encode(redirect, forKey: .redirect)
       }
       
       init() { }
}



extension ProcessCheckOutResponse {
   func processCheck(repsonseData: Data) -> ProcessCheckOutResponse? {
      do {
          let responseModel = try? JSONDecoder().decode(ProcessCheckOutResponse?.self,
           from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return ProcessCheckOutResponse.init()
   }
}
