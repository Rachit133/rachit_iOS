//
//  NotificationResponse.swift
//  Beer Connect
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct NotificationResponse: Codable {
    
    var data : [NotificationData]?
    var message : String?
    var status : String?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([NotificationData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    
    init() {}
}


struct NotificationData : Codable {
    
    var id : String?
    var image : String?
    var linkTo : String?
    var linkToData : String?
    var message : String?
    var status : String?
    var title : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case image = "image"
        case linkTo = "link_to"
        case linkToData = "link_to_data"
        case message = "message"
        case status = "status"
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        linkTo = try values.decodeIfPresent(String.self, forKey: .linkTo)
        linkToData = try values.decodeIfPresent(String.self, forKey: .linkToData)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
    
    init() {}
}

extension NotificationResponse {
    func getNotifcationDetails(repsonseData: Data) -> NotificationResponse? {
        do {
            let responseModel = try? JSONDecoder().decode(NotificationResponse?.self,
                                                          from: repsonseData)
            if responseModel != nil {
                print("Response Modal is \(String(describing: responseModel))")
                return responseModel
            }
        }
        return NotificationResponse.init()
    }
}
