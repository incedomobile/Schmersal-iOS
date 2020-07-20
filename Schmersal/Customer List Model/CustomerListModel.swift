//
//  CustomerListModel.swift
//  Schmersal
//
//  Created by Ankit on 28/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
struct CustomerListModel
{
    var customerID: Int
    var name: String
    var address: String
    var city: String
    var country: String
    var fed_state: String
    var assign_projects: String
    var customer_info: String
    
    init(custId:Int, name: String, address:String, cntry:String, city:String, f_state:String, a_project:String, cust_info:String)
    {
        self.customerID = custId
        self.name = name
        self.address = address
        self.country = cntry
        self.city = city
        self.fed_state = f_state
        self.assign_projects = a_project
        self.customer_info = cust_info
    }
}
