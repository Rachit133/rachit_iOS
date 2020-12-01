//
//  DahsboardResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 11/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit

struct DashboardResponse: Codable {
   var status: String?
   var name: String?
   var newArrivalProducts: MainProducts?
   var featuredProducts: MainProducts?
   var bestSellingProducts: CommonProducts?
   var dealProducts: CommonProducts?
   var allCategories: AllCategories?
   var homePageBanners: HomePageBanners?
   var bgImageUrl: String?
    var logoUrl: String?
   
    enum CodingKeys: String, CodingKey {
      case data = "data"
      case newArrivalProducts = "new_arrival_products"
      case allCategories = "all_categories"
      case featuredProducts = "featured_products"
      case bestSellingProducts = "best_selling_products"
      case homePageBanners = "home_page_banners"
      case dealProducts = "deal_products"
      case status = "status"
      case bgImageUrl = "bg_img"
      case logoUrl = "logo_url"
   }
   
   init(from decoder: Decoder) throws {
      
      let container = try decoder.container(keyedBy: CodingKeys.self)
      status = try container.decodeIfPresent(String.self, forKey: .status)
      let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
      
      newArrivalProducts = try data.decodeIfPresent(MainProducts.self, forKey: .newArrivalProducts)
      allCategories = try data.decodeIfPresent(AllCategories.self, forKey: .allCategories)
      featuredProducts = try data.decodeIfPresent(MainProducts.self, forKey: .featuredProducts)
      bestSellingProducts = try data.decodeIfPresent(CommonProducts.self, forKey: .bestSellingProducts)
      dealProducts = try data.decodeIfPresent(CommonProducts.self, forKey: .dealProducts)
      homePageBanners = try data.decodeIfPresent(HomePageBanners.self, forKey: .homePageBanners)
      bgImageUrl = try data.decodeIfPresent(String.self, forKey: .bgImageUrl)
     logoUrl = try data.decodeIfPresent(String.self, forKey: .logoUrl)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      var data = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
      try container.encode(status, forKey: .status)
      try data.encode(allCategories, forKey: .allCategories)
      try data.encode(newArrivalProducts, forKey: .newArrivalProducts)
      try data.encode(homePageBanners, forKey: .homePageBanners)
      try data.encode(dealProducts, forKey: .dealProducts)
      try data.encode(bestSellingProducts, forKey: .bestSellingProducts)
      try data.encode(featuredProducts, forKey: .featuredProducts)
   }
   
   init() { }
}

// MARK: - Products
struct MainProducts: Codable {
   
   var status: String?

   enum CodingKeys: String, CodingKey {
      case status = "status"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      status = try container.decodeIfPresent(String.self, forKey: .status)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(status, forKey: .status)
   }
   
   init() { }
}

// MARK: - All Categories
struct AllCategories: Codable {
   var categories: [ProductCategory]?
   var status: String?
   
   enum CodingKeys: String, CodingKey {
      case status = "status"
      case categories = "categories"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      status = try container.decodeIfPresent(String.self, forKey: .status)
      categories = try container.decodeIfPresent([ProductCategory].self, forKey: .categories)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(status, forKey: .status)
      try container.encode(categories, forKey: .categories)
   }
   
   init() { }

}


// MARK: - Category
struct CommonProducts: Codable {
   
   var products: [Product]?
   var status: String?
   var categoryId: Int? = 0
   
   enum CodingKeys: String, CodingKey {
      case products = "products"
      case status = "status"
      case categoryId = "category-id"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      categoryId = try container.decodeIfPresent(Int.self, forKey: .categoryId)
      products = try container.decodeIfPresent([Product].self, forKey: .products)
      status = try container.decodeIfPresent(String.self, forKey: .status)
   }
   
   // Encoding
     func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(categoryId, forKey: .categoryId)
      try container.encode(products, forKey: .products)
      try container.encode(status, forKey: .status)
   }
   
   init() { }
}

struct ProductItem: Codable {
   
   //var product_id: String?
   var product_name: String?
   var product_quantity: Int?
   var regular_price: String?
   var product_image: String?
   var currency_symbol: String?
 //  var product_type: String?
  
//   var product_price_min: String?
//   var product_price_max: String?
//   var product_price_min_reg: String?
//   var product_price_max_reg: String?
//   var sale: String?
//   var average_rating: String?
   var wishlist: String?
   
   enum CodingKeys: String, CodingKey {
    //  case product_id = "product_id"
      case product_name = "product_name"
      case product_quantity = "product_quantity"
      case product_image = "product_image"
      case currency_symbol = "currency_symbol"
    //  case product_type = "product_type"
      case regular_price = "regular_price"
     // case product_price_min = "product_price_min"
     // case product_price_max = "product_price_max"
     // case product_price_min_reg = "product_price_min_reg"
      //case product_price_max_reg = "product_price_max_reg"
      //case sale = "sale"
      //case average_rating = "average_rating"
      case wishlist = "wishlist"

   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
     // product_id = try container.decodeIfPresent(String.self, forKey: .product_id)
      product_name = try container.decodeIfPresent(String.self, forKey: .product_name) ?? "Rachit"
      product_quantity = try container.decodeIfPresent(Int.self, forKey: .product_quantity)
      product_image = try container.decodeIfPresent(String.self, forKey: .product_image)
     // currency_symbol = try container.decodeIfPresent(String.self, forKey: .currency_symbol)
     // product_type = try container.decodeIfPresent(String.self, forKey: .product_type)
      regular_price = try container.decodeIfPresent(String.self, forKey: .regular_price)
      //product_price_min = try container.decodeIfPresent(String.self, forKey: .product_price_min)
     // product_price_max = try container.decodeIfPresent(String.self, forKey: .product_price_max)
     // product_price_min_reg = try container.decodeIfPresent(String.self, forKey: .product_price_min_reg)
      //product_price_max_reg = try container.decodeIfPresent(String.self, forKey: .product_price_max_reg)
     // sale = try container.decodeIfPresent(String.self, forKey: .sale)
      //average_rating = try container.decodeIfPresent(String.self, forKey: .average_rating)
     // wishlist = try container.decodeIfPresent(String.self, forKey: .wishlist)

   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      //try container.encode(product_id, forKey: .product_id)
      try container.encode(product_name, forKey: .product_name)
      try container.encode(product_quantity, forKey: .product_quantity)
      try container.encode(product_image, forKey: .product_image)
   //   try container.encode(currency_symbol, forKey: .currency_symbol)
   //   try container.encode(product_type, forKey: .product_type)
      try container.encode(regular_price, forKey: .regular_price)
//      try container.encode(product_price_min, forKey: .product_price_min)
//      try container.encode(product_price_max, forKey: .product_price_max)
//      try container.encode(product_price_min_reg, forKey: .product_price_min_reg)
//      try container.encode(product_price_max_reg, forKey: .product_price_max_reg)
//      try container.encode(sale, forKey: .sale)
//      try container.encode(average_rating, forKey: .average_rating)
//      try container.encode(wishlist, forKey: .wishlist)
   }
}

// MARK: - Category
struct ProductCategory: Codable {
   
   var categoryName: String?
   var categoryID: Int?
   var categoryImage: String?
   var hasChild: Bool?
   
   enum CodingKeys: String, CodingKey {
      case categoryName = "category_name"
      case categoryID = "category_id"
      case categoryImage = "category_image"
      case hasChild = "has_child"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      categoryName = try container.decodeIfPresent(String.self, forKey: .categoryName)
      categoryID = try container.decodeIfPresent(Int.self, forKey: .categoryID)
      categoryImage = try container.decodeIfPresent(String.self, forKey: .categoryImage)
      hasChild = try container.decodeIfPresent(Bool.self, forKey: .hasChild)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(categoryName, forKey: .categoryName)
      try container.encode(categoryID, forKey: .categoryID)
      try container.encode(categoryImage, forKey: .categoryImage)
      try container.encode(hasChild, forKey: .hasChild)
   }
   
   init() { }
}

// MARK: - HomePageBanners
struct HomePageBanners: Codable { 
   var status: String?
   var banner: [Banner]?
   
   enum CodingKeys: String, CodingKey {
      case status = "status"
      case banner = "banner"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      status = try container.decodeIfPresent(String.self, forKey: .status)
      banner = try container.decodeIfPresent([Banner].self, forKey: .banner)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(status, forKey: .status)
      try container.encode(banner, forKey: .banner)
   }
   
   init() { }

}

// MARK: - Banner
struct Banner: Codable {
   
   var description, linkIdd, id, linkDisplay: String?
   var linkTo, title, status: String?
   var bannerURL: String?
   var layoutType: String?

   enum CodingKeys: String, CodingKey {
      case description = "description"
      case linkIdd = "link_idd"
      case id = "id"
      case linkDisplay = "link_display"
      case linkTo = "link_to"
      case title = "title"
      case status = "status"
      case bannerURL = "banner_url"
      case layoutType = "layout_type"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      description = try container.decodeIfPresent(String.self, forKey: .description)
      linkIdd = try container.decodeIfPresent(String.self, forKey: .linkIdd)
      id = try container.decodeIfPresent(String.self, forKey: .id)
      linkTo = try container.decodeIfPresent(String.self, forKey: .linkTo)
      title = try container.decodeIfPresent(String.self, forKey: .title)
      status = try container.decodeIfPresent(String.self, forKey: .status)
      bannerURL = try container.decodeIfPresent(String.self, forKey: .bannerURL)
      layoutType = try container.decodeIfPresent(String.self, forKey: .layoutType)
      linkDisplay = try container.decodeIfPresent(String.self, forKey: .linkDisplay)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(description, forKey: .description)
      try container.encode(linkIdd, forKey: .linkIdd)
      try container.encode(id, forKey: .id)
      try container.encode(linkDisplay, forKey: .linkDisplay)
      try container.encode(linkTo, forKey: .linkTo)
      try container.encode(title, forKey: .title)
      try container.encode(status, forKey: .status)
      try container.encode(bannerURL, forKey: .bannerURL)
      try container.encode(layoutType, forKey: .layoutType)
   }
   
   init() { }
}
