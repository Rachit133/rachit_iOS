//
//  CustomerListProtocol.swift
//  Beer Connect
//
//  Created by Apple on 30/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol CustomerListProtocol: class {
   @objc func onRecievedCustomerListSuccess()
   @objc func onFailure(errorMsg: String)
}

@objc protocol CustomerSelectedProtocol: class {
    @objc func onCustomerSelected(customerId: String)
}

