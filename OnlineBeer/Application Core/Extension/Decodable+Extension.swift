//
//  Decodable+Extension.swift
//  Beer Connect
//
//  Created by Synsoft on 29/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

extension Decodable {
    init(jsonData: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: jsonData)
    }
}

