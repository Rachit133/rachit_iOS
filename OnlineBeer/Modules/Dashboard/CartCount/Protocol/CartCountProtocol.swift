//
//  CartCountProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol CartCountProtocol: class {
   @objc func onRecievedItemCountSuccess()
   @objc func onFailure(errorMsg: String)
}
