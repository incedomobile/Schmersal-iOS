//
//  DataBaseHandler.swift
//  Schmersal
//
//  Created by Ankit on 27/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//
import UIKit

class DataBaseHandler: NSObject {
    
    var db: OpaquePointer? = nil
    var databasePath = NSString()
    var DATABASENAME = "Schmersal.db"
    
    // singleton class
    static let sharedInstance = DataBaseHandler()
    
    //To make copy of database in document file
    func initilizeDatabase()
    {
        let bundlePath = Bundle.main.path(forResource: "Schmersal", ofType: ".db")
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileMgr = FileManager.default
        let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent("Schmersal.db")
        if fileMgr.fileExists(atPath: fullDestPath.path){
            print("Database file is exist")
            print(fileMgr.fileExists(atPath: bundlePath!))
        }else{
            do{
                try fileMgr.copyItem(atPath: bundlePath!, toPath: fullDestPath.path)
                print("Copy Database Successfully at path: \(fileMgr.fileExists(atPath: bundlePath!))")
            }catch{
                print("\n",error)
                print("DB couldn't copy Successfully")
            }
        }
        
        
        //TODO:- Later on need to craete DB at run time
        /*
         let strDBPath: String = getDBPath(fileName: DATABASENAME as String)
         let fileManager = FileManager.default
         if !fileManager.fileExists(atPath: strDBPath)
         {
         let sqlStatement =  "CREATE TABLE IF NOT EXISTS tbl_customer (customer_id    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, address TEXT, city TEXT, country TEXT, federal_state TEXT, assigned_projects TEXT, customer_info TEXT);CREATE TABLE IF NOT EXISTS tbl_language_key (key_id    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, language_key TEXT, language_value TEXT, language_id INTEGER);CREATE TABLE IF NOT EXISTS tbl_map_customer (map_id    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, customer_id INTEGER, role_id INTEGER);CREATE TABLE IF NOT EXISTS tbl_role (role_id    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, role TEXT);CREATE TABLE IF NOT EXISTS tbl_supported_languages (language_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, language_code TEXT, language_name TEXT);CREATE TABLE IF NOT EXISTS tbl_user (user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, password TEXT, role_id INTEGER, language_id INTEGER, country TEXT, branch TEXT, access_authorization TEXT);"
         //            let strFromPath = urlForBundle!.appendingPathComponent(fileName as String)
         let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
         if (!isDBOpen)
         {
         print("DB could not open")
         }
         else{
         
         var error : NSError?
         do {
         try sqlite3_exec(db, sqlStatement, nil, nil, nil)
         
         } catch let error1 as NSError {
         error = error1
         }
         if (error != nil) {
         print("Error Occured")
         print("\((error?.localizedDescription)!)")
         } else {
         print("Database created Successfully")
         }
         }
         } else {
         print("DB is already exist into Your Device.")
         }
         */
    }
    
    //To open database
    func openDB(dbName:NSString) -> Bool{
        databasePath=getDBPath(fileName: dbName as String) as NSString
        if sqlite3_open(databasePath as String, &db) != SQLITE_OK {
            print("Databse is not open")
            print()
            return false
        }
        else
        {
            return true
        }
    }
    
    // get database path
    func getDBPath(fileName: String) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        print(fileURL)
        return fileURL.path
    }
    // For insert data in database
    func saveUserData(uid:Int,uname:String,pwd:String,roleId:Int ,langCode:String)
     {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        if (!isDBOpen)
        {
            //database is not open
        }
        else{
                let query = "INSERT INTO \(TBL_USER) (userid, username, password, roleid, langcode) VALUES ( \(uid), \"\(uname)\", \"\(pwd)\", \"\(roleId)\", \"\(langCode)\")"
                query.replacingOccurrences(of: "null", with: "")
                var cStatement:OpaquePointer? = nil
                let executeSql = query as NSString
                let sqlStatement = executeSql.cString(using: String.Encoding.utf8.rawValue)
                sqlite3_prepare_v2(db, sqlStatement, -1, &cStatement, nil)
                let execute = sqlite3_step(cStatement)
                print("\(execute)")
                if execute == SQLITE_DONE
                {
                    NSLog("Save user data successfully")
                }
                else
                {
                    print("Error in Run Statement :- \(String(describing: sqlite3_errmsg16(db)))")
                }
                sqlite3_finalize(cStatement)
                sqlite3_close(db);
        }
    }
    func saveCustomerMappingData( array:NSArray)
    {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        if (!isDBOpen)
        {
            //database is not open
        }
        else{
            for data in array {
                guard let val = data as? Response.Customers else {
                    return
                }
                let mapid = val.mapid
                let roleid = val.roleid
                let customerid = val.customerid
                let query = "INSERT INTO \(TBL_MAP_CUSTOMER) (map_id, customer_id, role_id) VALUES ( \(mapid), \"\(customerid)\", \"\(roleid)\")"
                query.replacingOccurrences(of: "null", with: "")
                var cStatement:OpaquePointer? = nil
                let executeSql = query as NSString
                let sqlStatement = executeSql.cString(using: String.Encoding.utf8.rawValue)
                sqlite3_prepare_v2(db, sqlStatement, -1, &cStatement, nil)
                let execute = sqlite3_step(cStatement)
                print("\(execute)")
                if execute == SQLITE_DONE
                {
                    NSLog("Save successfully")
                }
                else
                {
                    print("Error in Run Statement :- \(String(describing: sqlite3_errmsg16(db)))")
                }
                sqlite3_finalize(cStatement)
            }
            sqlite3_close(db);
        }
    }
    func saveCustomerList( array:NSArray)
    {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        if (!isDBOpen)
        {
            //database is not open
        }
        else{
            for data in array {
                guard let val = data as? CustomerList.Customers else {
                                   return
                               }
                let query = "INSERT INTO \(TBL_CUSTOMER) (customer_id, name, address, city, country, federal_state, assigned_projects, customer_info) VALUES ( \(val.customerid), \"\(val.name)\", \"\(val.address)\", \"\(val.city)\", \"\(val.country)\", \"\(val.federalstate)\", \"\(val.assignedprojects)\", \"\(val.customerinfo)\")"
                query.replacingOccurrences(of: "null", with: "")
                var cStatement:OpaquePointer? = nil
                let executeSql = query as NSString
                let sqlStatement = executeSql.cString(using: String.Encoding.utf8.rawValue)
                sqlite3_prepare_v2(db, sqlStatement, -1, &cStatement, nil)
                let execute = sqlite3_step(cStatement)
                print("\(execute)")
                if execute == SQLITE_DONE
                {
                    NSLog("Save successfully")
                }
                else
                {
                    print("Error in Run Statement :- \(String(describing: sqlite3_errmsg16(db)))")
                }
                sqlite3_finalize(cStatement)
            }
            sqlite3_close(db);
        }
    }
    
    //MARK: Fetch text on the behalf of lang
    func perfromSelectQueryForfetchingText(query:NSString) -> String {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        var txtStr:String = String()
        if (!isDBOpen)
        {
            //database is not open
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    txtStr = String(cString: sqlite3_column_text(queryStatement, 0))
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return txtStr as String
    }
    
    //For Delete Data
    func perfromDeleteQuery(query:NSString) -> Bool{
        
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        var isDeleted:Bool = false
        if (!isDBOpen)
        {
            //database is not open
        }
        else{
            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &deleteStatement, nil) == SQLITE_OK {
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted row.")
                    isDeleted = true
                } else {
                    print("Could not delete row.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_finalize(deleteStatement)
            sqlite3_close(db);
        }
        return isDeleted
    }
    
    
    // For Update data
    func performUpdateQuery(query:NSString)
    {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                
                if (sqlite3_step(queryStatement) == SQLITE_DONE) {
                    print("Update successfully")
                }
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
    }
    
    
    //For Checking either row is already esixted in db or not
    func perfromSelectQueryForCheckDataIsAlreadyEsitedOrNot(query:NSString) -> Bool{
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        var isExist = false
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                if sqlite3_step(queryStatement) == SQLITE_ROW {
                    // 3
                    isExist = true
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            
            // 6
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return isExist as Bool
    }
    
    //For Fetch Data
    func perfromSelectQueryForLanguages(query:NSString) -> NSArray {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        let arrayData = NSMutableArray()
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let langId = UInt32(sqlite3_column_int(queryStatement, 0))
                    let langCode = String(cString: sqlite3_column_text(queryStatement, 1))
                    let langName = String(cString: sqlite3_column_text(queryStatement, 2))
                    let langModel = LanguageModel(langId: Int(langId), langCode: langCode, langName: langName)
                    arrayData.add(langModel)
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return arrayData as NSArray
    }
    func perfromSelectQueryForUserList(query:NSString) -> NSArray {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        let arrayData = NSMutableArray()
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let userId = UInt32(sqlite3_column_int(queryStatement, 0))
                    let uname = String(cString: sqlite3_column_text(queryStatement, 1))
                    let pwd = String(cString: sqlite3_column_text(queryStatement, 2))
                    let roleId = UInt32(sqlite3_column_int(queryStatement, 3))
                     let langcode = String(cString: sqlite3_column_text(queryStatement, 4))
                    let langModel = UserModel(userId: Int(userId), username: uname, pwd: pwd, roleId: Int(roleId), langCode: langcode)
                    arrayData.add(langModel)
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return arrayData as NSArray
    }
    func perfromSelectQueryForRoles(query:NSString) -> NSArray {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        let arrayData = NSMutableArray()
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let roleId = UInt32(sqlite3_column_int(queryStatement, 0))
                    let role = String(cString: sqlite3_column_text(queryStatement, 1))
                    let role_de = String(cString: sqlite3_column_text(queryStatement, 2))
                    let model = RoleViewModel(roleid: Int(roleId), roleName: role, roleName_de: role_de)
                     arrayData.add(model)
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return arrayData as NSArray
    }
    func perfromSelectQueryForRoleID(query:NSString) -> Int {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        var roleID = 0
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    roleID = Int(UInt32(sqlite3_column_int(queryStatement, 0)))
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return roleID as Int
    }
    func perfromSelectQueryForCustomerList(query:NSString) -> NSArray {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        let arrayData = NSMutableArray()
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let custId = UInt32(sqlite3_column_int(queryStatement, 0))
                    let name = String(cString: sqlite3_column_text(queryStatement, 1))
                    let address = String(cString: sqlite3_column_text(queryStatement, 2))
                    let city = String(cString: sqlite3_column_text(queryStatement, 3))
                    let cntry = String(cString: sqlite3_column_text(queryStatement, 4))
                    let f_state = String(cString: sqlite3_column_text(queryStatement, 5))
                    let a_projects = String(cString: sqlite3_column_text(queryStatement, 6))
                    let cust_info = String(cString: sqlite3_column_text(queryStatement, 7))
                    let custModel = CustomerListModel(custId: Int(custId), name: name, address: address, cntry: cntry, city: city, f_state: f_state, a_project: a_projects, cust_info: cust_info)
                    arrayData.add(custModel)
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return arrayData as NSArray
    }
    func perfromSelectQueryForUser(query:NSString) -> Int {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        var userID : Int = 0
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                if sqlite3_step(queryStatement) == SQLITE_ROW {
                    userID = Int(UInt32(sqlite3_column_int(queryStatement, 0)))
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return userID
    }
    func perfromSelectQueryForUserRole(query:NSString) -> String {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        var userRole : String = ""
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                if sqlite3_step(queryStatement) == SQLITE_ROW {
                    userRole = String(cString: sqlite3_column_text(queryStatement, 0))
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return userRole
    }
    func perfromSelectQueryForUserCurrentLanguageCode(query:NSString) -> String {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        var userLangCode : String = ""
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                if sqlite3_step(queryStatement) == SQLITE_ROW {
                    userLangCode = String(cString: sqlite3_column_text(queryStatement, 0))
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return userLangCode
    }
    func perfromSelectQueryForValueOfKey(query:NSString) -> String {
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        var Value:String = ""
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                if sqlite3_step(queryStatement) == SQLITE_ROW {
                    Value = String(cString: sqlite3_column_text(queryStatement, 0))
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return Value
    }
    
    func perfromSelectQueryForRowsCount(query:NSString) -> Int {
        
        let isDBOpen : Bool = openDB(dbName: DATABASENAME as NSString)
        var count:Int! = 0
        if (!isDBOpen)
        {
            print("DB could not be open")
        }
        else{
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query as String, -1, &queryStatement, nil) == SQLITE_OK {
                if sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let total = UInt32(sqlite3_column_int(queryStatement, 0))
                    count = Int(total)
                }
            }
            else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        }
        sqlite3_close(db)
        return count as Int
    }
    
}
