//
//  Date+Extension.swift
//  Beer Connect
//
//  Created by Synsoft on 11/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

extension Date {
    // returns weekday name (Sunday-Saturday) as String
    var weekdayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
   func toString( dateFormat format: String ) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = format
       return dateFormatter.string(from: self)
   }
}

    

