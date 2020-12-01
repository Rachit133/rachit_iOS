//
//  GetWishlistResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 02/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - GetWishlistResponse
struct GetWishlistResponse: Codable {
   var wishlist: [Product]?
   var status, message: String?
   
   
   enum CodingKeys: String, CodingKey {
      case wishlist = "wishlist"
      case status = "status"
      case message = "message"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      wishlist = try container.decodeIfPresent([Product].self, forKey: .wishlist)
      status = try container.decodeIfPresent(String.self, forKey: .status)
      message = try container.decodeIfPresent(String.self, forKey: .message)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(wishlist, forKey: .wishlist)
      try container.encode(status, forKey: .status)
      try container.encode(message, forKey: .message)
   }
   
   init() { }
}


// MARK: - Wishlist
struct Wishlist: Codable {
   var productsId: Int?
   var productType, productName, currencySymbol: String?
   var productImage: String?
   var productGalleryStatus: Bool?
   var regularPrice, productPrice, averageRating, wishlist: String?
   var salePrice: String?
   var productQuntity: Int?
   //var productGallery: [String]? = [String].init()
   
   enum CodingKeys: String, CodingKey {
      case productsId = "product_id"
      case productType = "product_type"
      case productName = "product_name"
      case currencySymbol = "currency_symbol"
      case productImage = "product_image"
      case productGalleryStatus = "product-gallery-status"
      case regularPrice = "regular_price"
      case productPrice = "product_price"
      case averageRating = "average_rating"
      case wishlist = "wishlist"
      case productQuntity = "product_quantity"
      case salePrice = "salePrice"
      
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      productsId = try container.decodeIfPresent(Int.self, forKey: .productsId)
      productType = try container.decodeIfPresent(String.self, forKey: .productType)
      productName = try container.decodeIfPresent(String.self, forKey: .productName)
      currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
      productImage = try container.decodeIfPresent(String.self, forKey: .productImage)
      productGalleryStatus = try container.decodeIfPresent(Bool.self, forKey: .productGalleryStatus)
      regularPrice = try container.decodeIfPresent(String.self, forKey: .regularPrice)
      productPrice = try container.decodeIfPresent(String.self, forKey: .productPrice)
      averageRating = try container.decodeIfPresent(String.self, forKey: .averageRating)
      wishlist = try container.decodeIfPresent(String.self, forKey: .wishlist)
      salePrice = try container.decodeIfPresent(String.self, forKey: .salePrice)
      productQuntity = try container.decodeIfPresent(Int.self, forKey: .productQuntity)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(productsId, forKey: .productsId)
      try container.encode(productType, forKey: .productType)
      try container.encode(productName, forKey: .productName)
      try container.encode(currencySymbol, forKey: .currencySymbol)
      try container.encode(productImage, forKey: .productImage)
      try container.encode(productGalleryStatus, forKey: .productGalleryStatus)
      try container.encode(regularPrice, forKey: .regularPrice)
      try container.encode(productPrice, forKey: .productPrice)
      try container.encode(averageRating, forKey: .averageRating)
      try container.encode(wishlist, forKey: .wishlist)
      try container.encode(salePrice, forKey: .salePrice)
      try container.encode(productQuntity, forKey: .productQuntity)

   }
   
   init() { }
}

extension GetWishlistResponse {
   func fetchWishlistProducts(repsonseData: Data) -> GetWishlistResponse? {
      do {
            let responseModel = try? JSONDecoder().decode(GetWishlistResponse.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return GetWishlistResponse.init()
   }
}
