//
//  WebAPIUtility.swift
//  ProSoftConnect
//
//  Created by Ankit on 23/01/20.
//  Copyright © 2020 Ankit Manglik. All rights reserved.
//

import UIKit

let BASEURL = "http://54.193.236.56:8082/"

struct ApiUrls {
    static let registerURL = "register"
    static let authenticateURL = "authenticate"
    static let customerMappingURL = "getcustomerMapping"
    static let customerListURL = "getcustomers"
    static let customerSapListURL = "sap/getGermanCustomers"
}

class WebAPIUtility: NSObject {
    static let sharedInstance = WebAPIUtility()
    func getAPIResponses(urlPath: String,param:Dictionary<String, Any>,token:String,apiType:String, onSuccess: @escaping(Dictionary<String, AnyObject>) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = BASEURL + urlPath
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        if !param.isEmpty {
            var paramData : Data?
            do {
                paramData = try JSONSerialization.data(withJSONObject: param, options:[])
                request.httpBody = paramData
            } catch{
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if token != "" {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = apiType
        request.timeoutInterval = 200
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                guard let data = data else { return }
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, AnyObject> {
                        onSuccess(jsonResult)
                    }
                } catch let error {
                    print(error)
                    onFailure(error)
                }
            }
        })
        task.resume()
    }
}
