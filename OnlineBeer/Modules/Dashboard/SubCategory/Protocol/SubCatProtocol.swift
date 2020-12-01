//
//  SubCatProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 13/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol SubCatProtocol: class {
   @objc func onRecievedProductSuccess()
   @objc func onFailure(errorMsg: String)
}
