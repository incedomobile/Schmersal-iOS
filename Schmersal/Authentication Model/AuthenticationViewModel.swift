//
//  AuthenticationViewModel.swift
//  Schmersal
//
//  Created by Ankit on 02/06/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
public class AuthenticationViewModel {
    var selectedLanguage:String
    init(selectedLang:String) {
        self.selectedLanguage = selectedLang
    }
    
    public var Title: String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_auth_title", langCode: selectedLanguage)
    }
    
    public var SubTitle: String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_auth_subtitle", langCode: selectedLanguage)
    }
    public var ToggleSwitch: Bool {
        if UserDefaults.standard.value(forKey: "isTouchEnabled") != nil {
           return true
        }
        else {
            return false
        }
    }
}
