//
//  UserProfile.swift
//  Beer Connect
//
//  Created by Synsoft on 05/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct UserProfile {
   
   var name: String? = ""
   var imageName: String? = ""
   
   init(name: String? = "", imageName: String? = "") {
      self.name = name
      self.imageName = imageName
   }
}
