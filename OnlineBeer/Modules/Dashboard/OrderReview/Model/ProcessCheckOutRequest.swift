//
//  ProcessCheckOutRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 05/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - ProcessRequest
struct ProcessCheckOutRequest: Codable {
   var customerId: String?
   var shippingMethod: String?
   var orderNote: String?
   var PaymentMethod: String?
   var date1: String?
   var date2: String?
   var dateChanged: Bool?
   var isiOSDevice: String?
   var poNumber: String?
   var salesId: String?
   
    enum CodingKeys: String, CodingKey {
      case customerId = "customer_id"
      case shippingMethod = "shipping_method"
      case orderNote = "order_note"
      case PaymentMethod = "payment_method"
      case date1 = "jckwds-delivery-date-ymd"
      case date2 = "jckwds-delivery-date"
      case dateChanged = "jckwds-date-changed"
      case isiOSDevice = "isIOS"
      case poNumber = "po_number"
      case salesId = "sales_id"
   }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
      shippingMethod = try values.decodeIfPresent(String.self, forKey: .shippingMethod)
      orderNote = try values.decodeIfPresent(String.self, forKey: .orderNote)
      PaymentMethod = try values.decodeIfPresent(String.self, forKey: .PaymentMethod)
      date1 = try values.decodeIfPresent(String.self, forKey: .date1)
      date2 = try values.decodeIfPresent(String.self, forKey: .date2)
      dateChanged = try values.decodeIfPresent(Bool.self, forKey: .dateChanged)
      poNumber = try values.decodeIfPresent(String.self, forKey: .poNumber)
      isiOSDevice = try values.decodeIfPresent(String.self, forKey: .isiOSDevice)
      salesId = try values.decodeIfPresent(String.self, forKey: .salesId)
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["customer_id"] = self.customerId
      userDict["shipping_method"] = self.shippingMethod
      userDict["order_note"] = self.orderNote
      userDict["payment_method"] = self.PaymentMethod
      userDict["jckwds-delivery-date-ymd"] = self.date1
      userDict["jckwds-delivery-date"] = self.date2
      userDict["jckwds-date-changed"] = self.dateChanged
      userDict["isIOS"] = self.isiOSDevice
      userDict["po_number"] = self.poNumber
      userDict["sales_id"] = self.salesId
      return userDict
   }
   
   init() { }
   
  
}
