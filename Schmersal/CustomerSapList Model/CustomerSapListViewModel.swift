//
//  CustomerSapListViewModel.swift
//  Schmersal
//
//  Created by Ankit Manglik on 14/07/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
import UIKit
protocol SapCustomerProtocol {
    func callBackOfAPISapCustomers(isSuccess: Bool, response:SapCustomerList?)
}

public class CustomerSapListViewModel:NSObject, UITableViewDelegate, UITableViewDataSource  {
    var tblV:UITableView?
    var selectedLangCode:String?
    var custoDictionary = [String: [String]]()
    var custoSectionTitles = [String]()
    
    init(tblv:UITableView, selectedLangCode:String) {
        self.tblV = tblv
        self.selectedLangCode = selectedLangCode
        super.init()
       fetchSapCustomers()
    }
    func fetchSapCustomers() {
        if appDelegate.isInternetAvailable == true {
            let apiCall = APICalls()
            apiCall.delSapCustomer = self
           apiCall.fetchSapCustomers( langCode: selectedLangCode ?? "ES-EN")
           }
        else {
            showNoInternetConnectionAlert()
        }
    }
    func prepareTableIindex(custListArray: Array<Any>)  {
        for model in custListArray {
            let customerModel = model as! Customer
            let name = customerModel.customerName
            let key = String(name.prefix(1))
            if var keyValues = custoDictionary[key] {
                keyValues.append("\(name)__\(customerModel.customerNumber)")
                custoDictionary[key] = keyValues
            } else {
                custoDictionary[key] = ["\(name)__\(customerModel.customerNumber)"]
            }
        }
        custoSectionTitles = [String](custoDictionary.keys)
        custoSectionTitles = custoSectionTitles.sorted(by: { $0 < $1 })
        self.tblV?.reloadData()
    }
    public var navigationTitle : String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: "key_custo_list", langCode: selectedLangCode!)
    }
    
    // MARK: - Table view data source
    //    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return custoSectionTitles[section]
    //    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return custoSectionTitles.count
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return custoSectionTitles
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = custoSectionTitles[section]
        if let keyValues = custoDictionary[key] {
            return keyValues.count
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "MenuCell"
        var cell: MenuTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MenuTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MenuTableViewCell
        }
        
        let key = custoSectionTitles[indexPath.section]
        if let value = custoDictionary[key] {
            let fullValue = (value[indexPath.row] as String).components(separatedBy: "__")
            cell.lblTitle?.text = fullValue[0]
            cell.lblSubTitle?.text = fullValue[1]
        }
        return cell!
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension CustomerSapListViewModel: SapCustomerProtocol {
    func callBackOfAPISapCustomers(isSuccess: Bool, response:SapCustomerList?) {
        DispatchQueue.main.async {
            guard let resp = response else {
                return
            }
            if resp.mtMANGOCustomerListResponse.customer.count > 0 {
                self.prepareTableIindex(custListArray: resp.mtMANGOCustomerListResponse.customer)
            }
        }
    }
}
extension CustomerSapListViewModel {
   
    func showNoInternetConnectionAlert() {
        appDelegate.showToast(message:appDelegate.getText(key: "key_internet", langCode: selectedLangCode ?? "ES-EN"))
    }
}
