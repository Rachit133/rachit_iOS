//
//  OrderReview.swift
//  Beer Connect
//
//  Created by Synsoft on 02/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol OrderReviewProtocol: class {
   @objc func onOrderReviewSuccess()
   @objc func onOrderReviewFailure(errorMsg: String)
}
