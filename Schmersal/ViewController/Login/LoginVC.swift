//
//  LoginVC.swift
//  Schmersal
//
//  Created by Ankit on 23/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import UIKit
//protocol UpdateLanguageProtol {
//    func updateLanguage(langCode: String)
//}

class LoginVC: UIViewController{
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewPwd: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFilledUser: UIButton!
    @IBOutlet weak var txtPwd: UITextField!
    var viewModel : LoginLanguageViewModel?
    var userViewModel:UserListViewModel?
    var userDropDownViewModel:DropDownView?
    var selectedLangCode = ""
     var delegate:UpdateUIProtocol? = nil
    var km:KeyboardManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusbarColor()
        btnLogin.layer.cornerRadius = 3
        viewBorder.layer.cornerRadius = 5
        viewBorder.layer.borderWidth = 1
        viewBorder.layer.borderColor = MangoBlueColor.cgColor
        self.navigationController?.isNavigationBarHidden = false
        initialteViewModel()
        getAllUsers()
        km = KeyboardManager()
        km?.registerObserver(vController: self)
    }
    func setStatusbarColor()  {
        StatusBar.sharedInstanceOBJ.setStatusbarColor(v: self.view)
    }
    override func viewWillAppear(_ animated: Bool) {
        renderUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        setUpDropDown()
    }
    override func viewDidDisappear(_ animated: Bool) {
        km?.removeObserver()
    }
    func initialteViewModel() {
        selectedLangCode = UserDefaults.standard.value(forKey: "SELECTED_LANG") as! String
        viewModel = LoginLanguageViewModel(selectedLang: selectedLangCode)
    }
    func getAllUsers() {
        userViewModel = UserListViewModel(selectedLangCode: UserDefaults.standard.value(forKey: "SELECTED_LANG") as! String)
    }
    func renderUI()  {
        if let placeholder = viewModel?.pwdPlaceholder {
            txtPwd.placeholder = placeholder
        }
        if let btnLoginTitle = viewModel?.btnLogin {
            btnLogin.setTitle(btnLoginTitle, for: .normal)
        }
        if let uName = UserDefaults.standard.value(forKey: "USERNAME") {
            btnFilledUser.setTitle((uName as! String), for: .normal)
        }
    }
    @IBAction func showUserDropDown(_ sender: UIButton) {
        userDropDownViewModel?.showDropDown(sender)
    }
    @IBAction func getLogin(_ sender: UIButton) {
        view.endEditing(true)
        let uName = btnFilledUser.titleLabel?.text
        let pwd = txtPwd.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if pwd == "" {
            showAlert()
            return
        }
        let pwdBase64 = pwd.toBase64()
        let userID = DatabaseOperation.sharedInstanceOBJ.fetchUserTblData(uName: uName!.trimmingCharacters(in: .whitespacesAndNewlines), pwd: pwdBase64)
        if userID == 0 {
            showAlert()
            return
        }
        UserDefaults.standard.setValue(1, forKey: "isUserLoggedIn")
        UserDefaults.standard.setValue(selectedLangCode, forKey: "SELECTED_LANG")
        UserDefaults.standard.setValue(uName, forKey: "USERNAME")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func setUpDropDown(){
        userDropDownViewModel = DropDownView(dataArray:
            userViewModel!.userArray as NSArray, tag: 2, vc: self, langCode: selectedLangCode)
        userDropDownViewModel?.delegate = self
        
        let x = CGFloat(viewBorder.frame.origin.x + viewUser.frame.origin.x)
        let y = CGFloat(viewBorder.frame.origin.y + viewUser.frame.origin.y)
        let width = CGFloat(viewUser.frame.size.width)
        let height = CGFloat(viewUser.frame.size.height)
        let rect = CGRect(x: x, y: y, width: width, height: height)
        userDropDownViewModel?.setUpDropDown(frame: rect)
    }
    deinit {
        km?.removeObserver()
        km = nil
        userDropDownViewModel = nil
        viewModel = nil
        userViewModel = nil
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
}
extension LoginVC: DropDownViewProtocol{
    func selectedItemInDropDown(value: Any, tag:Int) {
        if tag == 2 {
            btnFilledUser.setTitle((value as! String), for: .normal)
                selectedLangCode = DatabaseOperation.sharedInstanceOBJ.fetchUserLangCode(uName: value as! String)
                viewModel?.selectedLanguage = selectedLangCode
                userViewModel?.selectedLangCode = selectedLangCode
            UserDefaults.standard.setValue(value, forKey: "USERNAME")
            renderUI()
            if let deleg = self.delegate as? AddAccountViewController
            {
                deleg.updateUI(uname: value as! String)
            }
        
        }
    }
    func showAlert() {
        appDelegate.showToast(message:appDelegate.getText(key: "key_wrong_credential_msg", langCode: selectedLangCode))
    }
}


