//
//  SearchProtocol.swift
//  Beer Connect
//
//  Created by Synsoft on 06/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

protocol SearchProtocol: class {
   func onSearchSuccess()
   func onSearchFailure(errorMsg: String)
   func onValidationErrorAlert(title: String, message: String)
}
