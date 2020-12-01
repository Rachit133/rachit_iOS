//
//  OrderDetailProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol OrderDetailProtocol: class {
   @objc func onReceivedOrderDetailSuccess()
   @objc func onReceivedOrderEmailDownloadSuccess()
   @objc func onDownloadFileSuccess(fileData: Data?)
   @objc func onFailure(errorMsg: String)
}
