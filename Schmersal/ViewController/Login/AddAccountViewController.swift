//
//  AddAccountViewController.swift
//  Schmersal
//
//  Created by Ankit on 22/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import UIKit
protocol UpdateUIProtocol {
    func updateUI(uname: String)
}


class AddAccountViewController: UIViewController {
    
    @IBOutlet weak var btnLanguage: UIButton!
     @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var btnPrefilledUser: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnAddAccount: UIButton!
    var langViewModel:LoginLanguageViewModel?
    var langDropDownViewModel:DropDownView?
    var isNavigationbarNeedToShow = true
    var viewModel:UserListViewModel?
    var dropDownViewModel:DropDownView?
    var selectedLangCode = "ES-EN"
    var del:UpdateUIProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusbarColor()
        btnOk.layer.cornerRadius = 3
        viewBorder.layer.cornerRadius = 5
        viewBorder.layer.borderWidth = 1
        viewBorder.layer.borderColor = MangoBlueColor.cgColor
        btnAddAccount.layer.cornerRadius = 3
        btnAddAccount.layer.borderWidth = 1;
        getAllUsers()
        getLanguages()
        renderUI()
    }
    func setStatusbarColor()  {
        StatusBar.sharedInstanceOBJ.setStatusbarColor(v: self.view)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = isNavigationbarNeedToShow
    }
    override func viewDidAppear(_ animated: Bool) {
        setUpDropDown()
    }
    
    @IBAction func goToHome(_ sender: UIButton) {
        DatabaseOperation.sharedInstanceOBJ.updateLangCode(langCode: selectedLangCode, uname: (btnPrefilledUser.titleLabel?.text!)!)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "loginvc") as! LoginVC
        vc.delegate = self
        UserDefaults.standard.setValue(selectedLangCode, forKey: "SELECTED_LANG")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func addAccount(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        var isExist = false
        let arrVC = (self.navigationController?.viewControllers)!
        for vc in arrVC {
            if vc is ViewController {
                (vc as! ViewController).isNavigationbarNeedToShow = true
                self.navigationController?.popToViewController(vc, animated: true)
                (vc as! ViewController).isInitialView = false
                (vc as! ViewController).isNavigationbarNeedToShow = true
                isExist = true
                break
            }
        }
        if isExist {
            return
        }
        let vc = storyBoard.instantiateViewController(withIdentifier: "login") as! ViewController
        vc.isInitialView = false
        vc.isNavigationbarNeedToShow = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getAllUsers() {
        selectedLangCode = DatabaseOperation.sharedInstanceOBJ.fetchUserLangCode(uName: UserDefaults.standard.value(forKey: "USERNAME") as! String)
        viewModel = UserListViewModel(selectedLangCode: selectedLangCode)
    }
    func getLanguages() {
        langViewModel = LoginLanguageViewModel(selectedLang: selectedLangCode)
    }
    func renderUI()  {
        
        if let okBtnText = viewModel?.btnOk {
            btnOk.setTitle(okBtnText, for: .normal)
        }
        if let addBtnText = viewModel?.addAccount {
            btnAddAccount.setTitle(addBtnText, for: .normal)
        }
        if let uName = UserDefaults.standard.value(forKey: "USERNAME") {
            btnPrefilledUser.setTitle((uName as! String), for: .normal)
        }
        if let btnLangTitle = langViewModel?.selectLanguage {
            btnLanguage.setTitle(btnLangTitle, for: .normal)
        }
    }
    @IBAction func showDropDown(_ sender: UIButton) {
        dropDownViewModel?.showDropDown(sender)
    }
    @IBAction func showLangDropDown(_ sender: UIButton) {
        langDropDownViewModel?.showDropDown(sender)
    }
    func setUpDropDown(){
        langDropDownViewModel = DropDownView(dataArray: langViewModel!.langArray as NSArray, tag: 1, vc: self, langCode: btnLanguage.titleLabel!.text!)
        langDropDownViewModel?.delegate = self
        langDropDownViewModel?.setUpDropDown(frame: btnLanguage.frame)
        
        dropDownViewModel = DropDownView(dataArray: viewModel!.userArray, tag: 2, vc: self, langCode: selectedLangCode)
        dropDownViewModel?.delegate = self
        let x = CGFloat(viewBorder.frame.origin.x + viewUser.frame.origin.x)
        let y = CGFloat(viewBorder.frame.origin.y + viewUser.frame.origin.y)
        let width = CGFloat(viewUser.frame.size.width)
        let height = CGFloat(viewUser.frame.size.height)
        let rect = CGRect(x: x, y: y, width: width, height: height)
        dropDownViewModel?.setUpDropDown(frame: rect)
    }
    deinit {
        viewModel = nil
        dropDownViewModel = nil
        langDropDownViewModel = nil
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }

}
extension AddAccountViewController: DropDownViewProtocol{
    
    func selectedItemInDropDown(value: Any, tag:Int) {
        if tag == 1 {
            let langModel = (value as! LanguageModel)
            selectedLangCode = langModel.languageCode
            langViewModel?.selectedLanguage = langModel.languageCode
            viewModel?.selectedLangCode = langModel.languageCode
            btnLanguage.setTitle(langModel.languageCode, for: .normal)
            renderUI()
//            if let deleg = self.delegate as? AddAccountViewController
//            {
//                deleg.updateLanguage(langCode: langModel.languageCode)
//            }
        }
        else if tag == 2 {
        btnPrefilledUser.setTitle((value as! String), for: .normal)
        UserDefaults.standard.setValue(value, forKey: "USERNAME")
            selectedLangCode = DatabaseOperation.sharedInstanceOBJ.fetchUserLangCode(uName: UserDefaults.standard.value(forKey: "USERNAME") as! String)
            viewModel?.selectedLangCode = selectedLangCode
            langViewModel?.selectedLanguage = selectedLangCode
        renderUI()
        }
    }
}
extension AddAccountViewController: UpdateUIProtocol {
    func updateUI(uname: String) {
        selectedLangCode = DatabaseOperation.sharedInstanceOBJ.fetchUserLangCode(uName: uname)
        viewModel?.selectedLangCode = selectedLangCode
        langViewModel?.selectedLanguage = selectedLangCode
        renderUI()
    }
}

