//
//  UserModel.swift
//  Schmersal
//
//  Created by Ankit on 27/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation

struct UserModel
 {
    var userID: Int
    var username: String
     var password: String
    var langCode: String
    var roleID: Int
     
    init(userId:Int, username: String, pwd:String, roleId:Int, langCode:String)
    {
        self.userID = userId
        self.username = username
        self.password = pwd
        self.roleID = roleId
        self.langCode = langCode
    }
}
