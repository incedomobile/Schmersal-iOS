//
//  SideMenuViewModel.swift
//  Schmersal
//
//  Created by Ankit on 28/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
public class SideMenuViewModel  {
    var selectedLangCode:String?
    init(selectedLangCode:String) {
        self.selectedLangCode = selectedLangCode
    }
    public var CustomerList : String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_custo_list", langCode: selectedLangCode!)
    }
    
    public var CustomerSapList : String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_custo_sap_list", langCode: selectedLangCode!)
    }
    public var Logout : String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_logout", langCode: selectedLangCode!)
    }
    public var Register : String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_register", langCode: selectedLangCode!)
    }
    public var AppName : String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_appname", langCode: selectedLangCode!)
    }
    public var Setting : String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_setting", langCode: selectedLangCode!)
    }
    public var WannaLogout : String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_wannalogout", langCode: selectedLangCode!)
    }
    public var Yes : String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_logout", langCode: selectedLangCode!)
    }
    public var No : String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_no", langCode: selectedLangCode!)
    }
}
