//
//  RegisterViewController.swift
//  Schmersal
//
//  Created by Ankit on 06/07/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import UIKit

protocol APIFinishedCallBackProtocol {
    func callBackOfAPIFinished(isSuccess: Bool)
}

class RegisterViewController: UIViewController {
    @IBOutlet weak var txtUname: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    var activeTxtFiled:UITextField?
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewPwd: UIView!
    @IBOutlet weak var viewRole: UIView!
    @IBOutlet weak var btnRole: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    var viewModel:LoginLanguageViewModel?
    var dropDownViewModel:DropDownView?
    var selectedLangCode = "ES-EN"
    var deleg:APIFinishedCallBackProtocol? = nil
    var km:KeyboardManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusbarColor()
        viewBorder.layer.cornerRadius = 5
        viewBorder.layer.borderWidth = 1
        viewBorder.layer.borderColor = MangoBlueColor.cgColor
        btnRegister.layer.cornerRadius = 3
        btnRegister.layer.borderWidth = 1;
        getAllRoles()
        renderUI()
        km = KeyboardManager()
        km?.registerObserver(vController: self)
    }
    func setStatusbarColor()  {
        StatusBar.sharedInstanceOBJ.setStatusbarColor(v: self.view)
    }
    override func viewDidAppear(_ animated: Bool) {
        setUpDropDown()
    }
    override func viewDidDisappear(_ animated: Bool) {
        km?.removeObserver()
    }
    @IBAction func toggleSideMenuBtn(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    @IBAction func registerUser(_ sender: UIButton) {
        view.endEditing(true)
        let uName = (self.view.viewWithTag(1) as! UITextField).text
        let pwd = (self.view.viewWithTag(2) as! UITextField).text
        
        if uName == "" || pwd == "" {
            showAlert()
            return
        }
        if appDelegate.isInternetAvailable == true {
            let apiCall = APICalls()
            apiCall.apiDel = self
            
            apiCall.registerUSER(uname: uName!, pwd: pwd!, langCode: selectedLangCode, roleId: viewModel?.selectedRole ?? 1)
        }
        else {
            showNoInternetConnectionAlert()
        }
    }
    func getAllRoles() {
        selectedLangCode = UserDefaults.standard.value(forKey: "SELECTED_LANG") as! String
        viewModel = LoginLanguageViewModel(selectedLang: selectedLangCode)
    }
    
    func renderUI()  {
        
        if let placeholder = viewModel?.uNamePlaceholder {
            txtUname.placeholder = placeholder
        }
        if let placeholder = viewModel?.pwdPlaceholder {
            txtPwd.placeholder = placeholder
        }
        if let btnRegisterTitle = viewModel?.btnRegister {
            btnRegister.setTitle(btnRegisterTitle, for: .normal)
        }
        if let btnRoleTitle = viewModel?.btnRole {
            btnRole.setTitle(btnRoleTitle, for: .normal)
        }
    }
    @IBAction func showDropDown(_ sender: UIButton) {
        dropDownViewModel?.showDropDown(sender)
    }
    
    func setUpDropDown() {
        dropDownViewModel = DropDownView(dataArray: viewModel!.roleArray as NSArray, tag: 2, vc: self, langCode: selectedLangCode)
        dropDownViewModel?.delegate = self
        let x = CGFloat(viewBorder.frame.origin.x + viewRole.frame.origin.x)
        let y = CGFloat(viewBorder.frame.origin.y + viewRole.frame.origin.y)
        let width = CGFloat(viewRole.frame.size.width)
        let height = CGFloat(viewRole.frame.size.height)
        let rect = CGRect(x: x, y: y, width: width, height: height)
        dropDownViewModel?.setUpDropDown(frame: rect)
    }
   
    deinit {
        km?.removeObserver()
        km = nil
        viewModel = nil
        dropDownViewModel = nil
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
}
extension RegisterViewController: DropDownViewProtocol{
    
    func selectedItemInDropDown(value: Any, tag:Int) {
        if tag == 2 {
            let model = (value as! RoleViewModel)
            btnRole.setTitle((model.role), for: .normal)
            viewModel?.selectedRole = model.roleID
        }
    }
}
extension RegisterViewController {
    func showAlert() {
        appDelegate.showToast(message:appDelegate.getText(key: "key_wrong_credential_msg", langCode: selectedLangCode))
    }
    func showNoInternetConnectionAlert() {
        appDelegate.showToast(message:appDelegate.getText(key: "key_internet", langCode: selectedLangCode))
    }
}
extension RegisterViewController: APIFinishedCallBackProtocol {
    func callBackOfAPIFinished(isSuccess: Bool)
    {
        DispatchQueue.main.async {
            if isSuccess == true {
                 appDelegate.showToast(message:appDelegate.getText(key: "key_appname", langCode: self.selectedLangCode))
                self.txtUname.text = ""
                self.txtPwd.text = ""
                
            }
            else {
                appDelegate.showToast(message:appDelegate.getText(key: "key_register_error", langCode: self.selectedLangCode))
            }
        }
    }
}
