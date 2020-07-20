//
//  CustomerSapListViewController.swift
//  Schmersal
//
//  Created by Ankit Manglik on 14/07/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import UIKit


class CustomerSapListViewController: UIViewController, ENSideMenuDelegate  {
    @IBOutlet weak var tblV: UITableView!
    var customerListViewModel:CustomerSapListViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusbarColor()
        renderUI()
    }
    
    func setStatusbarColor()  {
        StatusBar.sharedInstanceOBJ.setStatusbarColor(v: self.view)
    }
    @IBAction func toggleSideMenuBtn(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    func renderUI()  {
        customerListViewModel = CustomerSapListViewModel(tblv: tblV, selectedLangCode: UserDefaults.standard.value(forKey: "SELECTED_LANG") as! String)
        tblV.dataSource = (customerListViewModel!)
        tblV.delegate = (customerListViewModel!)
        tblV.sectionIndexColor = MangoBlueColor
        tblV.sectionIndexBackgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1)
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
