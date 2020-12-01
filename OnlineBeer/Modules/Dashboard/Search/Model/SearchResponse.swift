//
//  SearchResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 06/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
   var message: String?
   var status: String?
   var products: [Product]?
   var productCount: String?
   var filters: Filters?
   var orderBy: OrderBy?
   
   enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case products = "products"
        case filters = "filters"
        case orderBy = "order-by"
        case productCount = "product_count"
   }
   
   init() { }

   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      message = try values.decodeIfPresent(String.self, forKey: .message)
      status = try values.decodeIfPresent(String.self, forKey: .status)
      products = try values.decodeIfPresent([Product].self, forKey: .products)
      productCount = try values.decodeIfPresent(String.self, forKey: .productCount)
      filters = try values.decodeIfPresent(Filters.self, forKey: .filters)
      orderBy = try values.decodeIfPresent(OrderBy.self, forKey: .orderBy)

   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(status, forKey: .status)
      try container.encode(message, forKey: .message)
      try container.encode(products, forKey: .products)
      try container.encode(filters, forKey: .filters)
      try container.encode(orderBy, forKey: .orderBy)
    }
}

struct Products: Codable {
   
   var productGalleryStatus: Bool?
   var salePrice: String?
   var productImage: String?
   var productID: Int?
   var productGallery: Bool?
   var regularPrice, productPrice, productName, wishlist: String?
   let averageRating, currencySymbol, productPriceMax, productPriceMinReg: String?
   let productPriceMaxReg, productPriceMin: String?
   let sale: Bool?
   
   enum CodingKeys: String, CodingKey {
      case productGalleryStatus = "product-gallery-status"
      case salePrice = "sale_price"
      case productImage = "product_image"
      case productID = "product_id"
      case productGallery = "product-gallery"
      case regularPrice = "regular_price"
      case productPrice = "product_price"
      case productName = "product_name"
      case wishlist = "wishlist"
      case averageRating = "average_rating"
      case currencySymbol = "currency_symbol"
      case productPriceMax = "product_price_max"
      case productPriceMinReg = "product_price_min_reg"
      case productPriceMaxReg = "product_price_max_reg"
      case productPriceMin = "product_price_min"
      case sale = "sale"
   }
   
   init(from decoder: Decoder) throws {
      
      let container = try decoder.container(keyedBy: CodingKeys.self)
      productGalleryStatus = try container.decodeIfPresent(Bool.self, forKey: .productGalleryStatus)
      salePrice = try container.decodeIfPresent(String.self, forKey: .salePrice)
    
      productImage = try container.decodeIfPresent(String.self, forKey: .productImage)
      productID = try container.decodeIfPresent(Int.self, forKey: .productID)
      productGallery = try container.decodeIfPresent(Bool.self, forKey: .productGallery)
  
      regularPrice = try container.decodeIfPresent(String.self, forKey: .regularPrice)
      productPrice = try container.decodeIfPresent(String.self, forKey: .productPrice)
      productName = try container.decodeIfPresent(String.self, forKey: .productName)
      wishlist = try container.decodeIfPresent(String.self, forKey: .wishlist)

      averageRating = try container.decodeIfPresent(String.self, forKey: .averageRating)
      currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
      productPriceMax = try container.decodeIfPresent(String.self, forKey: .productPriceMax)
      productPriceMinReg = try container.decodeIfPresent(String.self, forKey: .productPriceMinReg)

      productPriceMaxReg = try container.decodeIfPresent(String.self, forKey: .productPriceMaxReg)
      productPriceMin = try container.decodeIfPresent(String.self, forKey: .productPriceMin)
      sale = try container.decodeIfPresent(Bool.self, forKey: .sale)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(productGalleryStatus, forKey: .productGalleryStatus)
      try container.encode(salePrice, forKey: .salePrice)
      try container.encode(productImage, forKey: .productImage)
      try container.encode(productID, forKey: .productID)
      try container.encode(productGallery, forKey: .productGallery)
      try container.encode(regularPrice, forKey: .regularPrice)
      try container.encode(productPrice, forKey: .productPrice)
      try container.encode(productName, forKey: .productName)
      try container.encode(wishlist, forKey: .wishlist)

      try container.encode(averageRating, forKey: .averageRating)
      try container.encode(currencySymbol, forKey: .currencySymbol)
      try container.encode(productPriceMax, forKey: .productPriceMax)
      try container.encode(productPriceMinReg, forKey: .productPriceMinReg)
      try container.encode(productPriceMaxReg, forKey: .productPriceMaxReg)

      try container.encode(productPriceMin, forKey: .productPriceMin)
      try container.encode(sale, forKey: .sale)
   }
}

