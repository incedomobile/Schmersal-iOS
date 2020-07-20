//
//  LoginLanguageViewModel.swift
//  Schmersal
//
//  Created by Ankit on 27/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
import UIKit
// MARK: - ViewModel
public class LoginLanguageViewModel {
    
    var langArray = [LanguageModel]()
    var roleArray = [RoleViewModel]()
    var selectedLanguage:String
    var selectedRole:Int = 1
    init(selectedLang:String) {
        self.selectedLanguage = selectedLang
        getAllLanguages()
        getAllRoles()
    }
    func getAllLanguages()  {
        self.langArray = DatabaseOperation.sharedInstanceOBJ.fetchLanguagesFromTable() as! [LanguageModel]
    }
    
    func getAllRoles()  {
        self.roleArray = (DatabaseOperation.sharedInstanceOBJ.fetchRoles() as! [RoleViewModel] as NSArray) as! [RoleViewModel]
        self.selectedRole = 1
    }
    
    public var uNamePlaceholder: String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_username", langCode: selectedLanguage)
    }
    
    public var pwdPlaceholder: String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_password", langCode: selectedLanguage)
    }
    public var selectLanguage: String {
        return selectedLanguage //DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_lang_name", langCode: selectedLanguage)
    }
    public var btnLogin: String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_login", langCode: selectedLanguage)
    }
    public var btnRegister: String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_btn_register", langCode: selectedLanguage)
    }
    public var btnRole: String {
        var roleName = ""
        for model in self.roleArray {
            if model.roleID == selectedRole {
                if selectLanguage == "ES-EN" {
                    roleName = model.role
                }
                else {
                    roleName = model.role_de
                }
                break
            }
        }
        return roleName
    }
    
}
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
}
