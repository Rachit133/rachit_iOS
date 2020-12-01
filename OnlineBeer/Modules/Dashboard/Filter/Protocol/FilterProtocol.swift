//
//  FilterProtocol.swift
//  Beer Connect
//
//  Created by Apple on 31/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: FILTER PROTOCOL
@objc protocol FilterProtocol: class {
    @objc func onReceivedFilterSuccess()
    @objc func onReceivedFilterSubCatSuccess()
    @objc func onFailure(errorMsg: String)
}
