//
//  OrderListResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct OrderListResponse : Codable {
    var order_count : String?
    var orders : [Orders]?
    var status : String?
    var message : String?
    var filterBy : FilterBy?

    enum CodingKeys: String, CodingKey {
        case order_count = "order_count"
        case orders = "orders"
        case status = "status"
        case message = "message"
        case filterBy = "filter_by"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_count = try values.decodeIfPresent(String.self, forKey: .order_count)
        orders = try values.decodeIfPresent([Orders].self, forKey: .orders)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        filterBy = try values.decodeIfPresent(FilterBy.self, forKey: .filterBy)
    }
    
    init() {}
}

struct FilterBy : Codable {
    
    var status : Status?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Status.self, forKey: .status)
    }
    
    init() {}
}

struct Status : Codable {
   var processing : String?
   var completed : String?

    enum CodingKeys: String, CodingKey {
        case processing = "processing"
        case completed = "completed"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        processing = try values.decodeIfPresent(String.self, forKey: .processing)
        completed = try values.decodeIfPresent(String.self, forKey: .completed)
    }

}

struct Orders : Codable {
   var orderNumber: String?
   var deliveryDate: String?
   var orderDate: String?
   var orderStatus: String?
   var orderTotal: String?
   var totalItems: Int?
   var currency: String?
   var orderTotalRefunded: Float?

    enum CodingKeys: String, CodingKey {
        case orderNumber = "order-number"
        case deliveryDate = "delivery_date"
        case orderDate = "order-date"
        case orderStatus = "order-status"
        case orderTotal = "order-total"
        case totalItems = "total-items"
        case orderTotalRefunded = "order-total-refunded"
        case currency = "currency"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderNumber = try values.decodeIfPresent(String.self, forKey: .orderNumber)
        deliveryDate = try values.decodeIfPresent(String.self, forKey: .deliveryDate)
        orderDate = try values.decodeIfPresent(String.self, forKey: .orderDate)
        orderStatus = try values.decodeIfPresent(String.self, forKey: .orderStatus)
        orderTotal = try values.decodeIfPresent(String.self, forKey: .orderTotal)
        totalItems = try values.decodeIfPresent(Int.self, forKey: .totalItems)
        orderTotalRefunded = try values.decodeIfPresent(Float.self, forKey: .orderTotalRefunded)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
    }
}

extension OrderListResponse {
   func getOrderListObjectFrom(repsonseData: Data) -> OrderListResponse? {
      do {
         let responseModel = try? JSONDecoder().decode(OrderListResponse?.self,
                                                       from: repsonseData)
         if responseModel != nil {
           // print("Response Modal is \(String(describing: responseModel))")
            return responseModel
        }
      }
      return OrderListResponse.init()
   }
}


