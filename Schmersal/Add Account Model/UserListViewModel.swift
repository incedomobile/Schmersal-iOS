//
//  UserListViewModel.swift
//  Schmersal
//
//  Created by Ankit on 27/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
import UIKit
// MARK: - ViewModel
public class UserListViewModel {
    
    var userArray:NSArray = [UserModel]() as NSArray
    var selectedLangCode:String
    init(selectedLangCode:String) {
        self.selectedLangCode = selectedLangCode
        getAllUsers()
    }
    func getAllUsers()  {
        self.userArray = DatabaseOperation.sharedInstanceOBJ.fetchUserList() as! [UserModel] as NSArray
    }
    
    public var btnOk: String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_ok", langCode: selectedLangCode)
    }
    public var addAccount: String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_add_aacount", langCode: selectedLangCode)
    }
}
