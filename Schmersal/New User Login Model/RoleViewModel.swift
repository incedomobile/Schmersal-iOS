//
//  RoleViewModel.swift
//  Schmersal
//
//  Created by Ankit on 02/07/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation

struct RoleViewModel
 {
    var roleID: Int
    var role: String
    var role_de: String
    
    init(roleid:Int, roleName: String, roleName_de:String) {
        self.roleID = roleid
        self.role = roleName
        self.role_de = roleName_de
    }
}
