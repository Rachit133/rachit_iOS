//
//  ShippingDetailProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
@objc protocol ShippingDetailsProtocol: class {
   @objc func onRecievedShippingDetailsSuccess()
   @objc func onRecievedSaveAddressSuccess(data: Data)
   @objc func onDetailsFailure(errorMsg: String)
}

@objc protocol CalenderPopUpProtocol: class {
   @objc func getSelectedDate(selectedDateStr: String)
}
