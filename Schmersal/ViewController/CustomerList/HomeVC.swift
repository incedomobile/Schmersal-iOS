//
//  HomeVC.swift
//  Schmersal
//
//  Created by Ankit on 23/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, ENSideMenuDelegate  {
    @IBOutlet weak var tblV: UITableView!
    var customerListViewModel:CustomerListViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusbarColor()
        self.navigationController?.isNavigationBarHidden = false
        self.sideMenuController()?.sideMenu?.delegate = self
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = true
        self.sideMenuController()?.sideMenu?.allowPanGesture = true
        if let vc = self.sideMenuController()?.sideMenu?.menuViewController as? MyMenuTableViewController {
            let roleID = DatabaseOperation.sharedInstanceOBJ.fetchRoleID(uName: UserDefaults.standard.value(forKey: "USERNAME") as! String)
            if roleID == 1 {
                vc.numberOfRows = 5
            }
            else {
                vc.numberOfRows = 4
            }
            vc.tableView.reloadData()
            vc.renderUI()
        }
        renderUI()
    }
    
    func setStatusbarColor()  {
        StatusBar.sharedInstanceOBJ.setStatusbarColor(v: self.view)
    }
    @IBAction func toggleSideMenuBtn(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    func renderUI()  {
        customerListViewModel = CustomerListViewModel(uName: UserDefaults.standard.value(forKey: "USERNAME") as! String, selectedLangCode: UserDefaults.standard.value(forKey: "SELECTED_LANG") as! String)
        tblV.dataSource = (customerListViewModel!)
        tblV.delegate = (customerListViewModel!)
        tblV.sectionIndexColor = MangoBlueColor
        tblV.sectionIndexBackgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1)
//        if let navTitle = customerListViewModel?.navigationTitle {
//            self.title = navTitle
//        }
    }
    deinit {
        customerListViewModel = nil
    }
    // MARK: - SideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    

    
}

