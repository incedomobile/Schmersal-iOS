//
//  ApiCalls.swift
//  Schmersal
//
//  Created by Ankit on 03/07/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
import UIKit

class APICalls  {
    
    var apiDelegate:APICallBackProtocol? = nil
    var apiDel:APIFinishedCallBackProtocol? = nil
    var delSapCustomer:SapCustomerProtocol? = nil
    
    func registerUSER(uname:String, pwd:String, langCode:String, roleId:Int) {
        DispatchQueue.main.async {
            appDelegate.progressView.startAnimation()
            appDelegate.progressView.loaderText.text = appDelegate.getText(key: "key_loading", langCode: langCode)
        }
        var postParam = [String:Any]()
        
        postParam = [
            "username":uname,
            "password":pwd,
            "roleid":roleId]
        
        WebAPIUtility.sharedInstance.getAPIResponses(urlPath: ApiUrls.registerURL, param: postParam, token: "", apiType: "POST", onSuccess: { (resp) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                _ = try JSONDecoder().decode(Register.self, from: jsonData)
                DispatchQueue.main.async {
                    if let deleg = self.apiDel as? RegisterViewController
                    {
                        deleg.callBackOfAPIFinished(isSuccess: true)
                    }
                    appDelegate.progressView.stopAnimation()
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    if let deleg = self.apiDel as? RegisterViewController
                    {
                        deleg.callBackOfAPIFinished(isSuccess: false)
                    }
                    appDelegate.progressView.stopAnimation()
                }
                DispatchQueue.main.async {
                    appDelegate.progressView.stopAnimation()
                }
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                appDelegate.progressView.stopAnimation()
            }
        })
    }
    func loginUSER(uname:String, pwd:String, langCode:String) {
        DispatchQueue.main.async {
            appDelegate.progressView.startAnimation()
            appDelegate.progressView.loaderText.text = appDelegate.getText(key: "key_loggingin", langCode: langCode)
        }
        var postParam = [String:Any]()
        postParam = [
            "username":uname,
            "password":pwd]
        
        WebAPIUtility.sharedInstance.getAPIResponses(urlPath: ApiUrls.authenticateURL, param: postParam, token: "", apiType: "POST", onSuccess: { (resp) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let auth = try JSONDecoder().decode(Authenticate.self, from: jsonData)
                DispatchQueue.main.async {
                    let pwdBase64 = pwd.trimmingCharacters(in: .whitespacesAndNewlines).toBase64()
                    DispatchQueue.main.async {
                        DatabaseOperation.sharedInstanceOBJ.saveDataInTbl_User(uid: auth.userDAO.id, uname: auth.userDAO.username, pwd: pwdBase64, roleId: auth.userDAO.roleid, langCode: langCode)
                    }
                }
                UserDefaults.standard.setValue(1, forKey: "isUserLoggedIn")
                UserDefaults.standard.setValue(langCode, forKey: "SELECTED_LANG")
                UserDefaults.standard.setValue(uname, forKey: "USERNAME")
                
                if UserDefaults.standard.value(forKey: "isSynced") == nil {
                    DispatchQueue.main.async {
                        appDelegate.progressView.loaderText.text = appDelegate.getText(key: "key_syncing", langCode: langCode)
                    }
                    self.insertCustomerMappingData(token: auth.token)
                }
                else {
                    DispatchQueue.main.async {
                        if let deleg = self.apiDelegate as? ViewController
                        {
                            deleg.callBackOfAPI(isUserLoggedIn: true)
                        }
                        appDelegate.progressView.stopAnimation()
                    }
                }
                
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    if let deleg = self.apiDelegate as? ViewController
                    {
                        deleg.callBackOfAPI(isUserLoggedIn: false)
                    }
                    appDelegate.progressView.stopAnimation()
                }
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                appDelegate.progressView.stopAnimation()
            }
        })
    }
    func insertCustomerMappingData(token:String) {
        let postParam = [String:Any]()
        WebAPIUtility.sharedInstance.getAPIResponses(urlPath: ApiUrls.customerMappingURL, param: postParam, token: token, apiType: "GET", onSuccess: { (resp) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let response = try JSONDecoder().decode(Response.self, from: jsonData)
                
                if response.mapCustomers.count > 0 {
                    DispatchQueue.main.async { DatabaseOperation.sharedInstanceOBJ.saveDataInTbl_CustomerMappingData(dataArray: response.mapCustomers as NSArray)
                    }
                }
                self.insertCustomers(token: token)
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    appDelegate.progressView.stopAnimation()
                }
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                appDelegate.progressView.stopAnimation()
            }
        })
    }
    func insertCustomers(token:String) {
        let postParam = [String:Any]()
        WebAPIUtility.sharedInstance.getAPIResponses(urlPath: ApiUrls.customerListURL, param: postParam, token: token, apiType: "GET", onSuccess: { (resp) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let response = try JSONDecoder().decode(CustomerList.self, from: jsonData)
                if response.customers.count > 0 {
                    DispatchQueue.main.async { DatabaseOperation.sharedInstanceOBJ.saveDataInTbl_Customer(dataArray: response.customers as NSArray)
                    }
                }
                DispatchQueue.main.async {
                    UserDefaults.standard.setValue("1", forKey: "isSynced")
                    UserDefaults.standard.synchronize()
                    if let deleg = self.apiDelegate as? ViewController
                    {
                        deleg.callBackOfAPI(isUserLoggedIn: true)
                    }
                    appDelegate.progressView.stopAnimation()
                }
                
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    appDelegate.progressView.stopAnimation()
                }
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                appDelegate.progressView.stopAnimation()
            }
        })
    }
    func fetchSapCustomers(langCode:String) {
        DispatchQueue.main.async {
            appDelegate.progressView.startAnimation()
            appDelegate.progressView.loaderText.text = appDelegate.getText(key: "key_loading", langCode: langCode)
        }
        let postParam = [String:Any]()
         
        WebAPIUtility.sharedInstance.getAPIResponses(urlPath: ApiUrls.customerSapListURL, param: postParam, token: "", apiType: "GET", onSuccess: { (resp) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let sapCustomerList = try JSONDecoder().decode(SapCustomerList.self, from: jsonData)
                
                DispatchQueue.main.async {
                    if let deleg = self.delSapCustomer as? CustomerSapListViewModel
                    {
                        deleg.callBackOfAPISapCustomers(isSuccess: true, response: sapCustomerList)
                    }
                    appDelegate.progressView.stopAnimation()
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    if let deleg = self.delSapCustomer as? CustomerSapListViewModel
                    {
                        deleg.callBackOfAPISapCustomers(isSuccess: false, response: nil)
                    }
                    appDelegate.progressView.stopAnimation()
                }
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                appDelegate.progressView.stopAnimation()
            }
        })
    }
}
