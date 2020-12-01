//
//  ForgotPassResponse.swift
//  Beer Connect
//
//  Created by Apple on 02/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct ForgotPassResponse : Codable {
    var data : ForgotPassData?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ForgotPassData.self, forKey: .data)
    }
    
    init() {}
}

struct ForgotPassData : Codable {
    
    var customer : ForgotPassCustomer?
    
    enum CodingKeys: String, CodingKey {
        case customer = "customer"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer = try values.decodeIfPresent(ForgotPassCustomer.self, forKey: .customer)
    }
    
    init() {}
}

struct ForgotPassCustomer : Codable {
    var message : String?
    var status : String?
    
    enum CodingKeys: String, CodingKey {
        
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    
    init() {}
}

extension ForgotPassResponse {
    func getForgotPassDetails(repsonseData: Data) -> ForgotPassResponse? {
        do {
            let responseModel = try? JSONDecoder().decode(ForgotPassResponse.self,
                                                          from: repsonseData)
            if responseModel != nil {
                print("Response Modal is \(String(describing: responseModel))")
                return responseModel
            } else {
                return ForgotPassResponse.init()
            }
        }
    }
}
