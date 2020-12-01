
import Foundation

// MARK: - RemoveItemResponse
struct RemoveItemResponse: Codable {
   
   var cartId: CartIds?

   enum CodingKeys: String, CodingKey {
     case cartId = "cart_id"
   }
        
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      cartId = try container.decodeIfPresent(CartIds.self, forKey: .cartId)
   }
        
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(cartId, forKey: .cartId)
   }
        
   init() { }
}

// MARK: - CartID
struct CartIds: Codable {
   
    var itemsCount: Int?
    var itemsCountStatus, success: Bool?
    var cartId, message: String?
   
   enum CodingKeys: String, CodingKey {
       case cartId = "cart_id"
       case itemsCount = "items_count"
       case itemsCountStatus = "items_count_status"
       case success = "success"
       case message = "message"
     }
          
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cartId = try container.decodeIfPresent(String.self, forKey: .cartId)
        itemsCount = try container.decodeIfPresent(Int.self, forKey: .itemsCount)
        itemsCountStatus = try container.decodeIfPresent(Bool.self, forKey: .itemsCountStatus)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        message = try container.decodeIfPresent(String.self, forKey: .message)
     }
          
     // Encoding
     func encode(to encoder: Encoder) throws {
       var container = encoder.container(keyedBy: CodingKeys.self)
       try container.encode(cartId, forKey: .cartId)
       try container.encode(itemsCount, forKey: .itemsCount)
       try container.encode(itemsCountStatus, forKey: .itemsCountStatus)
       try container.encode(success, forKey: .success)
       try container.encode(message, forKey: .message)
     }
          
     init() { }
}

extension RemoveItemResponse {
   func removeItemFrom(repsonseData: Data) -> RemoveItemResponse? {
      do {
            let responseModel = try? JSONDecoder().decode(RemoveItemResponse?.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return RemoveItemResponse.init()
   }
}

