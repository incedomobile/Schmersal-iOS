//
//  AuthEnableViewController.swift
//  Schmersal
//
//  Created by Ankit on 02/06/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import UIKit

class AuthEnableViewController: UIViewController {
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    var viewModel : AuthenticationViewModel?
    var isToggleChanged = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mango"
        if UserDefaults.standard.value(forKey: "isTouchEnabled") != nil {
            btnSwitch.isOn = true
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.userAuthentication),
            name: NSNotification.Name(rawValue: "USERAUTHENTICATION"),
            object: nil)
        renderUI()
        // Do any additional setup after loading the view.
    }
    func renderUI() {
        viewModel = AuthenticationViewModel(selectedLang: UserDefaults.standard.value(forKey: "SELECTED_LANG") as! String)
        if let title = viewModel?.Title {
            lblHeaderTitle.text = title
        }
        if let subTitle = viewModel?.SubTitle {
            lblSubTitle.text = subTitle
        }
        if let authenticate = viewModel?.ToggleSwitch {
            btnSwitch.isOn = authenticate
        }
    }
    @IBAction func toggleSideMenuBtn(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    @IBAction func authenticateUser(_ sender: Any) {
        isToggleChanged = true
        appDelegate.authWithTouchId()
    }
    @objc private func userAuthentication(notification: NSNotification){
        
        if let value = notification.object as? Bool {
            if value == true {
                print("Authenticated")
                if UserDefaults.standard.value(forKey: "isTouchEnabled") != nil {
                    if isToggleChanged == true {
                        btnSwitch.isOn = false
                        UserDefaults.standard.removeObject(forKey: "isTouchEnabled")
                    }
                    
                }
                else {
                    if isToggleChanged == true {
                        btnSwitch.isOn = true
                        UserDefaults.standard.setValue(1, forKey: "isTouchEnabled")
                    }
                    
                }
                
            }
            else {
                print("Not authenticated")
                if isToggleChanged == true {
                    btnSwitch.isOn = false
                }
            }
            isToggleChanged = false
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("USERAUTHENTICATION"), object: nil)
    }
}
extension AuthEnableViewController:ENSideMenuDelegate {
    func sideMenuWillOpen() {
        
    }
    func sideMenuWillClose() {
        
    }
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    func sideMenuDidOpen() {
        
    }
    func sideMenuDidClose() {
        
    }
}
