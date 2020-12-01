//
//  HTTPUrlResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 29/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
     func isResponseOK() -> Bool {
      return (200...299).contains(self.statusCode)
     }
    
}
