//
//  DatabaseOperation.swift
//  Schmersal
//
//  Created by Ankit on 27/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import UIKit
let TBL_CUSTOMER = "tbl_customer"
let TBL_LANGUAGE_KEY = "tbl_language_key"
let TBL_MAP_CUSTOMER = "tbl_map_customer"
let TBL_ROLE = "tbl_role"
let TBL_SUPPORTED_LANGUAGES = "tbl_supported_languages"
let TBL_USER = "tbl_user"

class DatabaseOperation: NSObject {
    
    let dbHandler = DataBaseHandler.sharedInstance
    static let sharedInstanceOBJ = DatabaseOperation()
    
    /*
     //MARK:- to Save/Update Data
     func saveDataInDetailTable(parms :NSDictionary)
     {
     
     let name = parms.object(forKey: "name") as! NSString
     let address = parms.object(forKey: "address") as! NSString
     let serial = parms.object(forKey: "serial") as! NSString
     let checkStatementString = "SELECT Name FROM Detail WHERE Serial =  \"\(serial)\" AND Address = \"\(address)\""
     
     let isAlreadySaved = dbHandler.perfromSelectQueryForCheckDataIsAlreadyEsitedOrNot(query: checkStatementString as NSString)
     
     if(isAlreadySaved)
     {
     // Update here
     let updateStatementString = "UPDATE Detail SET Name = \"\(name)\" WHERE Address =  \"\(address)\" AND Serial = \"\(serial)\""
     dbHandler.performUpdateQuery(query: updateStatementString as NSString)
     }
     else{
     
     //Data insertion
     let insertStatementString = "INSERT INTO Detail (Name, Address) VALUES ( \"\(name)\", \"\(address)\")"
     
     dbHandler.performSaveQuery(query: insertStatementString as NSString)
     }
     }
     */
    // Update here
    func updateLangCode(langCode:String, uname:String)
    {
        let updateStatementString = "UPDATE \(TBL_USER) SET langcode = \"\(langCode)\" WHERE username =  \"\(uname)\""
        dbHandler.performUpdateQuery(query: updateStatementString as NSString)
    }
    func saveDataInTbl_User(uid:Int,uname:String,pwd:String,roleId:Int,langCode:String)
    {
        dbHandler.saveUserData(uid: uid, uname: uname, pwd: pwd, roleId: roleId, langCode: langCode)
    }
    func saveDataInTbl_Customer(dataArray :NSArray)
    {
        dbHandler.saveCustomerList(array:dataArray)
    }
    func saveDataInTbl_CustomerMappingData(dataArray :NSArray)
    {
        dbHandler.saveCustomerMappingData(array:dataArray)
    }
    
    func fetchLanguagesFromTable() -> NSArray
    {
        let fetchStatementString = "SELECT * FROM \(TBL_SUPPORTED_LANGUAGES)"
        return dbHandler.perfromSelectQueryForLanguages(query: fetchStatementString as NSString) as NSArray
    }
    func fetchCustListFromTable(uName:String) -> NSArray {
        let key1 = String(format: "'%@'",uName)
        //SELECT * from tbl_customer WHERE customer_id in (SELECT customer_id from tbl_map_customer WHERE role_id = (SELECT role_id from tbl_user WHERE name = 'ROM') )
        
        let fetchStatementString = "SELECT * from \(TBL_CUSTOMER) WHERE customer_id in (SELECT customer_id from \(TBL_MAP_CUSTOMER) WHERE role_id = (SELECT roleid FROM tbl_user WHERE username = \(key1)))"
        return dbHandler.perfromSelectQueryForCustomerList(query: fetchStatementString as NSString) as NSArray
    }
    func fetchUserList() -> NSArray
    {
        let fetchStatementString = "SELECT * FROM \(TBL_USER)"
        return dbHandler.perfromSelectQueryForUserList(query: fetchStatementString as NSString) as NSArray
    }
    func fetchRoles() -> NSArray
    {
        let fetchStatementString = "SELECT * FROM \(TBL_ROLE)"
        return dbHandler.perfromSelectQueryForRoles(query: fetchStatementString as NSString) as NSArray
    }
    func fetchRoleID(uName:String) -> Int
    {
        let key = String(format: "'%@'",uName)
        let fetchStatementString = "SELECT roleid FROM \(TBL_USER) WHERE username = \(key)"
        return dbHandler.perfromSelectQueryForRoleID(query: fetchStatementString as NSString) as Int
    }
    func fetchValueForKey(key:String, langCode:String) -> String
    {
        let key1 = String(format: "'%@'",key)
        let langCode1 = String(format: "'%@'",langCode)
        let fetchStatementString = "SELECT language_value FROM \(TBL_LANGUAGE_KEY) WHERE language_key = \(key1) AND language_id = (SELECT language_id from \(TBL_SUPPORTED_LANGUAGES) WHERE language_code = \(langCode1))"
        return dbHandler.perfromSelectQueryForValueOfKey(query: fetchStatementString as NSString) as String
    }
    func fetchUserTblData(uName:String, pwd:String) -> Int
    {
        let key1 = String(format: "'%@'",uName)
        let key2 = String(format: "'%@'",pwd)
        let fetchStatementString = "SELECT userid FROM \(TBL_USER) WHERE username = \(key1) AND password = \(key2)"
        return dbHandler.perfromSelectQueryForUser(query: fetchStatementString as NSString) as Int
    }
    func fetchUserRole(uName:String, currentLangCode:String) -> String
    {
        let key1 = String(format: "'%@'",uName)
        var key2 = ""
        if currentLangCode == "ES-EN" {
            key2 = "role"
        }
        else {
            key2 = "role_de"
        }
            
         let fetchStatementString = "SELECT \(key2) FROM \(TBL_ROLE) WHERE role_id = (SELECT roleid from \(TBL_USER) WHERE username = \(key1))"
        return dbHandler.perfromSelectQueryForUserRole(query: fetchStatementString as NSString) as String
    }
    func fetchUserLangCode(uName:String) -> String
    {
        let key1 = String(format: "'%@'",uName)
        let fetchStatementString = "SELECT langcode FROM \(TBL_USER) WHERE username = \(key1)"
        return dbHandler.perfromSelectQueryForUserCurrentLanguageCode(query: fetchStatementString as NSString) as String
    }
    //perfromSelectQuery
    func getRowsCount(name: String) -> Int
    {
        let fetchStatementString =  "SELECT COUNT(Address) from Detail WHERE Name =\"\(name)\""
        return dbHandler.perfromSelectQueryForRowsCount(query: fetchStatementString as NSString) as Int
    }
    
    //perfromDeleteQuery
    func deleteRow(name :String) -> Bool
    {
        let fetchStatementString =  "DELETE from Detail WHERE Name =\"\(name)\""
        return dbHandler.perfromDeleteQuery(query: fetchStatementString as NSString) as Bool
    }
    
    func isNull(string : AnyObject?) -> AnyObject? {
        
        //let x: AnyObject = NSNull()
        if (string as? String) != nil {
            return string
        } else {
            return "" as AnyObject?
        }
        
    }
    
    
}
