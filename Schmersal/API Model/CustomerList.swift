//
//  CustomerList.swift
//  Schmersal
//
//  Created by Ankit on 01/07/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation

// MARK: - Register
struct Register: Codable {
    let id: Int
    let username: String
    let roleid: Int
    
    enum CodingKeys: String, CodingKey {
        case id, username, roleid
    }
}

// MARK: - Authentication
struct Authenticate: Codable {
    let userDAO: UserDAO
    let token: String

    enum CodingKeys: String, CodingKey {
        case userDAO = "userDao"
        case token
    }
}

// MARK: - UserDAO
struct UserDAO: Codable {
    let id: Int
    let username: String
    let roleid: Int
}

// MARK: - Mapping Customer
struct Response: Codable
{
    struct Customers: Codable {
        let customerid:Int
        let mapid:Int
        let roleid:Int
    }
    var mapCustomers:[Customers]
}

// MARK: - Customer List
struct CustomerList: Codable
{
    struct Customers: Codable {
        let customerid: Int
        let name, address, city, country: String
        let federalstate, assignedprojects, customerinfo: String
    }
    var customers:[Customers]
}

// MARK: - Sap Customer List
struct SapCustomerList: Codable {
    let mtMANGOCustomerListResponse: MTMANGOCustomerListResponse

    enum CodingKeys: String, CodingKey {
        case mtMANGOCustomerListResponse = "MT_MANGO_CustomerList_Response"
    }
}

// MARK: - MTMANGOCustomerListResponse
struct MTMANGOCustomerListResponse: Codable {
    let username: String
    let customer: [Customer]
}

// MARK: - Customer
struct Customer: Codable {
    let customerNumber: Int
    let customerName: String
}
