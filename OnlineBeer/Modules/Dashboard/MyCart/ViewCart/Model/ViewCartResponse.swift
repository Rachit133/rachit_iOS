//
//  AddToCartResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 20/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - ViewCartResponse
struct ViewCartResponse: Codable {
    var data: DataDict?
    var status: Bool?
   
   enum CodingKeys: String, CodingKey {
      case data = "data"
      case status = "status"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      data = try container.decodeIfPresent(DataDict.self, forKey: .data)
      status = try container.decodeIfPresent(Bool.self, forKey: .status)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(data, forKey: .data)
      try container.encode(status, forKey: .status)
   }
   
   init() { }
   
}

// MARK: - DataClass
struct DataDict: Codable {
    var taxLabel: String?
    var products: [CartProduct]?
    var itemsCount: Int?
    var outofstockstatus: Bool? = false
    var outofstockmsg: String? = ""
    var cartSubtotal, currencySymbol, discountAmount, cartTotal, amountSaved: String?
   
   enum CodingKeys: String, CodingKey {
      case taxLabel = "tax_label"
      case products = "products"
      case itemsCount = "items_count"
      case cartSubtotal = "cart_subtotal"
      case currencySymbol = "currency_symbol"
      case discountAmount = "discount_amount"
      case cartTotal = "cart_total"
      case amountSaved = "discount_amount_total"
      case outofstockstatus = "outofstockstatus"
      case outofstockmsg = "outofstockmsg"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      taxLabel = try container.decodeIfPresent(String.self, forKey: .taxLabel)
      products = try container.decodeIfPresent([CartProduct].self, forKey: .products)
      itemsCount = try container.decodeIfPresent(Int.self, forKey: .itemsCount)
      cartSubtotal = try container.decodeIfPresent(String.self, forKey: .cartSubtotal)
      currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
      discountAmount = try container.decodeIfPresent(String.self, forKey: .discountAmount)
      cartTotal = try container.decodeIfPresent(String.self, forKey: .cartTotal)
      amountSaved = try container.decodeIfPresent(String.self, forKey: .amountSaved)
      outofstockmsg = try container.decodeIfPresent(String.self, forKey: .outofstockmsg)
      outofstockstatus = try container.decodeIfPresent(Bool.self, forKey: .outofstockstatus)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(taxLabel, forKey: .taxLabel)
      try container.encode(products, forKey: .products)
      try container.encode(itemsCount, forKey: .itemsCount)
      try container.encode(cartSubtotal, forKey: .cartSubtotal)
      try container.encode(currencySymbol, forKey: .currencySymbol)
      try container.encode(discountAmount, forKey: .discountAmount)
      try container.encode(cartTotal, forKey: .cartTotal)
      try container.encode(amountSaved, forKey: .amountSaved)
   }
   
   init() { }
}


// MARK: - Product
struct CartProduct: Codable {
   var productID: Int? = 0
   var quantity: Int? = 0
   var productSubtotal: String? = ""
   // var variationID: Int? = 0
   var productImage: String? = ""
   var productPrice, cartKey, currencySymbol, productType, origionalPrice: String?
   var productName: String?
   var stockQuantity : Int? = 0
   var productDiscount: String? = ""
   var outofstockstatus: Bool? = false
    
   enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case quantity = "quantity"
        case productSubtotal = "product_subtotal"
        case variationID = "variation_id"
        case productImage = "product_image"
        case productPrice = "product_price"
        case origionalPrice = "original_price"
        case cartKey = "cart_key"
        case currencySymbol = "currency_symbol"
        case productType = "product_type"
        case productName = "product_name"
        case productDiscount = "discount_amount_total"
        case outofstockstatus = "outofstockstatus"
     }
     
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productID = try container.decodeIfPresent(Int.self, forKey: .productID)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        productSubtotal = try container.decodeIfPresent(String.self, forKey: .productSubtotal)
       // variationID = try container.decodeIfPresent(Int.self, forKey: .variationID)
        productImage = try container.decodeIfPresent(String.self, forKey: .productImage)
        productPrice = try container.decodeIfPresent(String.self, forKey: .productPrice)
        origionalPrice = try container.decodeIfPresent(String.self, forKey: .origionalPrice)
        cartKey = try container.decodeIfPresent(String.self, forKey: .cartKey)
        currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
        productType = try container.decodeIfPresent(String.self, forKey: .productType)
        productName = try container.decodeIfPresent(String.self, forKey: .productName)
        productDiscount = try container.decodeIfPresent(String.self, forKey: .productDiscount)
        outofstockstatus = try container.decodeIfPresent(Bool.self, forKey: .outofstockstatus)
     }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productID, forKey: .productID)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(productSubtotal, forKey: .productSubtotal)
        //try container.encode(variationID, forKey: .variationID)
        try container.encode(productImage, forKey: .productImage)
        try container.encode(productPrice, forKey: .productPrice)
        try container.encode(cartKey, forKey: .cartKey)
        try container.encode(currencySymbol, forKey: .currencySymbol)
        try container.encode(productType, forKey: .productType)
        try container.encode(productName, forKey: .productName)
     }
}


extension ViewCartResponse {
   func getMyCartDetailsFrom(repsonseData: Data) -> ViewCartResponse? {
      do {
            let responseModel = try? JSONDecoder().decode(ViewCartResponse?.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return ViewCartResponse.init()
   }
}
