//
//  LaunchProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 06/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol LaunchProtocol: class {
   @objc func onRecievedSuccess()
   @objc func onFailure(errorMsg: String)
}
