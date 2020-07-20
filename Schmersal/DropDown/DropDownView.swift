//
//  DropDownView.swift
//  Schmersal
//
//  Created by Ankit on 28/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
import UIKit

protocol DropDownViewProtocol {
    func selectedItemInDropDown(value: Any, tag:Int)
}

public class DropDownView : MakeDropDownDataSourceProtocol {
    var dataArray:NSArray = [] as NSArray
    lazy var langArray:NSMutableArray = [] as NSMutableArray
    var viewController:UIViewController?
    var tag:Int = 0
    let dropDown = MakeDropDown()
    var delegate:DropDownViewProtocol? = nil
    var selectedLangCode:String
    
    init(dataArray:NSArray, tag:Int, vc:UIViewController, langCode:String) {
        self.dataArray = dataArray
        self.viewController = vc
        self.tag = tag
        self.selectedLangCode = langCode
    }
    
    func showDropDown(_ sender: UIButton) {
        if self.tag == 1 {
            langArray.removeAllObjects()
            if dataArray.count > 0 {
                for model in dataArray {
                    if (model as! LanguageModel).languageCode != self.selectedLangCode {
                        langArray.add(model)
                    }
                }
            }
        }
        else {
            langArray.removeAllObjects()
        }
        var height = 50
        if dataArray.count > 4 {
            height = 200
        }
        else {
            height = 50 * ((tag == 2) ? dataArray.count : langArray.count)
        }
        self.dropDown.showDropDown(height:CGFloat(height))
    }
    
    func setUpDropDown(frame:CGRect) {
        dropDown.makeDropDownIdentifier = "DROP_DOWN_NEW"
        dropDown.cellReusableIdentifier = "dropDownCell"
        dropDown.makeDropDownDataSourceProtocol = self as MakeDropDownDataSourceProtocol
        dropDown.setUpDropDown(viewPositionReference: frame, offset: 2)
        dropDown.nib = UINib(nibName: "DropDownTableViewCell", bundle: nil)
        dropDown.setRowHeight(height: 50)
        self.viewController?.view.addSubview(dropDown)
    }
    
    func getDataToDropDown(cell: UITableViewCell, indexPos: Int, makeDropDownIdentifier: String) {
        if makeDropDownIdentifier == "DROP_DOWN_NEW"{
            let customCell = cell as! DropDownTableViewCell
            if tag == 1 {
                let langObj = langArray.object(at: indexPos) as! LanguageModel
                customCell.lblLanguageName .text = "      \(langObj.languageCode)"
            }
            else if tag == 2 {
                if ((self.delegate as? ViewController) != nil) || ((self.delegate as? RegisterViewController) != nil) {
                    let roleObj = dataArray.object(at: indexPos) as! RoleViewModel
                    if self.selectedLangCode == "ES-EN" {
                        customCell.lblLanguageName .text = roleObj.role
                    }
                    else {
                        customCell.lblLanguageName .text = roleObj.role_de
                    }
                }
                else {
                let langObj = dataArray.object(at: indexPos) as! UserModel
                customCell.lblLanguageName .text = langObj.username
                }
            }
        }
    }
    
    func numberOfRows(makeDropDownIdentifier: String) -> Int {
        if tag == 1 {
            return langArray.count
        }
        else if tag == 2 {
            return dataArray.count
        }
        return 0
    }
    
    func selectItemInDropDown(indexPos: Int, makeDropDownIdentifier: String) {
        if tag == 2 {
            
            if let deleg = self.delegate as? AddAccountViewController
            {
                let userModel = dataArray.object(at: indexPos) as! UserModel
                deleg.selectedItemInDropDown(value: userModel.username,tag: 2)
                UserDefaults.standard.setValue(userModel.username, forKey: "USERNAME")
            }
            else if let deleg = self.delegate as? ViewController
            {
                let roleModel = dataArray.object(at: indexPos) as! RoleViewModel
                deleg.selectedItemInDropDown(value: roleModel,tag: 2)
            }
            else if let deleg = self.delegate as? RegisterViewController
            {
                let roleModel = dataArray.object(at: indexPos) as! RoleViewModel
                deleg.selectedItemInDropDown(value: roleModel,tag: 2)
            }
                
            else if let deleg = self.delegate as? LoginVC
            {
                let userModel = dataArray.object(at: indexPos) as! UserModel
                deleg.selectedItemInDropDown(value: userModel.username,tag: 2)
                UserDefaults.standard.setValue(userModel.username, forKey: "USERNAME")
            }
        }
        else if tag == 1 {
            let langModel = langArray.object(at: indexPos) as! LanguageModel
            if let deleg = self.delegate as? ViewController
            {
                deleg.selectedItemInDropDown(value: langModel, tag: 1)
                self.selectedLangCode = langModel.languageCode
            }
            else if let deleg = self.delegate as? RegisterViewController
            {
                deleg.selectedItemInDropDown(value: langModel, tag: 1)
                self.selectedLangCode = langModel.languageCode
            }
            else if let deleg = self.delegate as? AddAccountViewController
            {
                deleg.selectedItemInDropDown(value: langModel, tag: 1)
                self.selectedLangCode = langModel.languageCode
            }
        }
        self.dropDown.hideDropDown()
    }
    
}
