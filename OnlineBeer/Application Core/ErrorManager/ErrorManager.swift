//
//  ErrorManager.swift
//  CVDelight_Partner
//
//  Created by Apple on 21/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

// MARK: Error Handelling
struct ErrorManager: Error {
   
    var errorCode: Int?
    var msg: String?
    
    init(errorCode: Int = 0, message: String) {
        self.errorCode = errorCode
        self.msg = message
    }
}
