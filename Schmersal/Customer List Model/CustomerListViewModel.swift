//
//  CustomerListViewModel.swift
//  Schmersal
//
//  Created by Ankit on 28/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
import UIKit

public class CustomerListViewModel:NSObject, UITableViewDelegate, UITableViewDataSource  {
    var uName:String?
    var selectedLangCode:String?
    var custoDictionary = [String: [String]]()
    var custoSectionTitles = [String]()
    
    init(uName:String, selectedLangCode:String) {
        self.uName = uName
        self.selectedLangCode = selectedLangCode
        super.init()
        self.prepareTableIindex(custListArray: DatabaseOperation.sharedInstanceOBJ.fetchCustListFromTable(uName: uName) as NSArray)
    }
    func prepareTableIindex(custListArray:NSArray)  {
        for model in custListArray {
            let customerModel = model as! CustomerListModel
            let name = customerModel.name
            let key = String(name.prefix(1))
            if var keyValues = custoDictionary[key] {
                keyValues.append("\(name)__\(customerModel.address), \(customerModel.city), \(customerModel.fed_state)")
                custoDictionary[key] = keyValues
            } else {
                custoDictionary[key] = ["\(name)__\(customerModel.address), \(customerModel.city), \(customerModel.fed_state)"]
            }
        }
        custoSectionTitles = [String](custoDictionary.keys)
        custoSectionTitles = custoSectionTitles.sorted(by: { $0 < $1 })
        
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
