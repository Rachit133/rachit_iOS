//
//  NSObject+Extension.swift
//  Beer Connect
//
//  Created by Synsoft on 11/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
extension NSObject {
    enum DateFormatType: String {
        /// Time
        case time = "HH:mm:ss"
        
        /// Date with hours
        case dateWithTime = "yyyy-MM-dd HH:mm:ss"
        
        /// Date
        case date = "dd-MM-yyyy"
    }
    /// Convert String to Date
    func convertToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatType.date.rawValue // Your date format
        let serverDate: Date = dateFormatter.date(from: dateString)! // according to date format your date string
        return serverDate
    }
}
