//
//  PaymentTypeProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 03/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol PaymentMethodProtocol: class {
   @objc func onPaymentMethodTapped(methodType: String)
   @objc func onFailure(errorMsg: String)
}
