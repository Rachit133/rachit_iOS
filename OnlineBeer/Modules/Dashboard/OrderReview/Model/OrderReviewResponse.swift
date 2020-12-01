//
//  OrderReviewResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 02/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - OrderReviewResponse
struct OrderReviewResponse: Codable {
    var data: OrderReviewDataClass?
    var success: Bool?
    var code: String?
    var message: String?
    
   enum CodingKeys: String, CodingKey {
      case data = "data"
      case success = "success"
      case code = "code"
      case message = "message"
    }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      success = try container.decodeIfPresent(Bool.self, forKey: .success)
      data = try container.decodeIfPresent(OrderReviewDataClass.self, forKey: .data)
      message = try container.decodeIfPresent(String.self, forKey: .message)
      code = try container.decodeIfPresent(String.self, forKey: .code)
    }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(success, forKey: .success)
      try container.encode(data, forKey: .data)
      try container.encode(message, forKey: .message)
      try container.encode(code, forKey: .code)
    }
   
   init() { }
}


// MARK: - DataClass
struct OrderReviewDataClass: Codable {
   
    var taxLabel, cartSubtotal: String?
    var discountAmount: Int?
    var currencySymbol, cartTotal: String?
    var itemsCount: Int?
    var products: [CartProduct]?
    var chosenMethod: [String]?
    var chosenPaymentMethod: String?
    var shippingTotal: String?
    var gateways: [Gateway]?
    var allowCheckout, ratesStatus: Bool?
    var rates: Rates?
    var amountSaved: String?
    
   enum CodingKeys: String, CodingKey {
      case taxLabel = "tax_label"
      case cartSubtotal = "cart_subtotal"
      case discountAmount = "discount_amount"
      case currencySymbol = "currency_symbol"
      case cartTotal = "cart_total"
      case itemsCount = "items_count"
      case products = "products"
      case chosenMethod = "chosen_method"
      case chosenPaymentMethod = "chosen_payment_method"
      case shippingTotal = "shipping_total"
      case gateways = "gateways"
      case allowCheckout = "allow_checkout"
      case ratesStatus = "rates_status"
      case rates = "rates"
      case amountSaved = "discount_amount_total"

   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      taxLabel = try container.decodeIfPresent(String.self, forKey: .taxLabel)
      cartSubtotal = try container.decodeIfPresent(String.self, forKey: .cartSubtotal)
      discountAmount = try container.decodeIfPresent(Int.self, forKey: .discountAmount)
      currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
      cartTotal = try container.decodeIfPresent(String.self, forKey: .cartTotal)
      itemsCount = try container.decodeIfPresent(Int.self, forKey: .itemsCount)
      products = try container.decodeIfPresent([CartProduct].self, forKey: .products)
      amountSaved = try container.decodeIfPresent(String.self, forKey: .amountSaved)
     // chosenMethod = try container.decodeIfPresent([String].self, forKey: .chosenMethod)
      chosenPaymentMethod = try container.decodeIfPresent(String.self, forKey: .chosenPaymentMethod)
      shippingTotal = try container.decodeIfPresent(String.self, forKey: .shippingTotal)
      gateways = try container.decodeIfPresent([Gateway].self, forKey: .gateways)
      allowCheckout = try container.decodeIfPresent(Bool.self, forKey: .allowCheckout)
      ratesStatus = try container.decodeIfPresent(Bool.self, forKey: .ratesStatus)
      rates = try container.decodeIfPresent(Rates.self, forKey: .rates)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(taxLabel, forKey: .taxLabel)
      try container.encode(cartSubtotal, forKey: .cartSubtotal)
      try container.encode(discountAmount, forKey: .discountAmount)
      try container.encode(currencySymbol, forKey: .currencySymbol)
      try container.encode(cartTotal, forKey: .cartTotal)
      try container.encode(itemsCount, forKey: .itemsCount)
      try container.encode(products, forKey: .products)
      try container.encode(chosenMethod, forKey: .chosenMethod)
      try container.encode(chosenPaymentMethod, forKey: .chosenPaymentMethod)
      try container.encode(shippingTotal, forKey: .shippingTotal)
      try container.encode(gateways, forKey: .gateways)
      try container.encode(allowCheckout, forKey: .allowCheckout)
      try container.encode(ratesStatus, forKey: .ratesStatus)
      try container.encode(rates, forKey: .rates)
      try container.encode(amountSaved, forKey: .amountSaved)
   }
   
   init() { }
}


struct Gateway : Codable {

     var descriptionField : String?
     var id : String?
     var methodTitle : String?
     var title : String?

    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case id = "id"
        case methodTitle = "method_title"
        case title = "title"
    }
   
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        methodTitle = try values.decodeIfPresent(String.self, forKey: .methodTitle)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
}

// MARK: - Rates
struct Rates: Codable {
    var freeShipping: FreeShipping?
   
   enum CodingKeys: String, CodingKey {
      case freeShipping = "free_shipping"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      freeShipping = try container.decodeIfPresent(FreeShipping.self, forKey: .freeShipping)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(freeShipping, forKey: .freeShipping)
   }
   
   init() { }
}

// MARK: - FreeShipping1
struct FreeShipping: Codable {
   
    var id, methodID: String?
    var instanceID: Int?
    var label, cost: String?
    var taxes: [String?]?
    var finalCost: Int?
   
   enum CodingKeys: String, CodingKey {
      case id = "id"
      case methodID = "method_id"
      case instanceID = "instance_id"
      case cost = "cost"
      case taxes = "taxes"
      case label = "label"
      case finalCost = "final_cost"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decodeIfPresent(String.self, forKey: .id)
      methodID = try container.decodeIfPresent(String.self, forKey: .methodID)
      instanceID = try container.decodeIfPresent(Int.self, forKey: .instanceID)
      cost = try container.decodeIfPresent(String.self, forKey: .cost)
      taxes = try container.decodeIfPresent([String].self, forKey: .taxes)
      label = try container.decodeIfPresent(String.self, forKey: .label)
      finalCost = try container.decodeIfPresent(Int.self, forKey: .finalCost)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(methodID, forKey: .methodID)
      try container.encode(instanceID, forKey: .instanceID)
      try container.encode(cost, forKey: .cost)
      try container.encode(taxes, forKey: .taxes)
      try container.encode(label, forKey: .label)
      try container.encode(finalCost, forKey: .finalCost)
   }
   
   init() { }
}



extension OrderReviewResponse {
   func getCheckDetails(repsonseData: Data) -> OrderReviewResponse? {
      do {
            let responseModel = try? JSONDecoder().decode(OrderReviewResponse?.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return OrderReviewResponse.init()
   }
}
