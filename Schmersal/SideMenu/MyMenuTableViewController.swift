//
//  MyMenuTableViewController.swift
//  Schmersal
//
//  Created by Ankit on 25/05/20.
//  Copyright © 2020 Ankit. All rights reserved.
//


import UIKit

class MyMenuTableViewController: UITableViewController {
    
    private let menuOptionCellId = "Cell"
    var selectedMenuItem : Int = 0
    var sideMenuViewModel:SideMenuViewModel?
    var numberOfRows = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
               tableView.contentInset = UIEdgeInsets(top: 52.0, left: 0, bottom: 0, right: 0)
        }
        else
        {
              tableView.contentInset = UIEdgeInsets(top: 43.0, left: 0, bottom: 0, right: 0)
        }
        
        //tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = UIColor.white
        tableView.scrollsToTop = false
        clearsSelectionOnViewWillAppear = false
        tableView.separatorStyle = .none
        
        // Preselect a menu option
//        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .middle)
        renderUI()
    }
    
    
    func renderUI() {
        var currentLang = "ES-EN"
        if let selectedLangCode = UserDefaults.standard.value(forKey: "SELECTED_LANG") {
            currentLang = selectedLangCode as! String
        }
        sideMenuViewModel = SideMenuViewModel(selectedLangCode:currentLang )
        setTblCellTintColor(index: selectedMenuItem, isSet: true)
    }
    deinit {
        sideMenuViewModel = nil
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: menuOptionCellId)
        
        if (cell == nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier: menuOptionCellId)
            cell!.backgroundColor = .clear
            //            cell!.selectionStyle = .default
            cell!.textLabel?.textColor = .darkGray
            let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        if indexPath.row == 0 {
            if let ttile = sideMenuViewModel?.CustomerList {
                cell!.textLabel?.text = ttile
            }
            cell!.imageView?.image = UIImage(named: "custlist")
        }
        else if indexPath.row == 1 {
            if let setting = sideMenuViewModel?.CustomerSapList {
                cell!.textLabel?.text = setting
            }
            cell!.imageView?.image = UIImage(named: "custlist")
        }
        else if indexPath.row == 2 {
            if let setting = sideMenuViewModel?.Setting {
                cell!.textLabel?.text = setting
            }
            cell!.imageView?.image = UIImage(named: "setting")
        }
        else if indexPath.row == 3 {
            if numberOfRows == 4 {
                if let ttile = sideMenuViewModel?.Logout {
                    cell!.textLabel?.text = ttile
                }
                cell!.imageView?.image = UIImage(named: "logout")
            }
            else if numberOfRows == 5 {
                if let ttile = sideMenuViewModel?.Register {
                    cell!.textLabel?.text = ttile
                }
                cell!.imageView?.image = UIImage(named: "register")
            }
        }
        else if indexPath.row == 4 {
            if let ttile = sideMenuViewModel?.Logout {
                cell!.textLabel?.text = ttile
            }
            cell!.imageView?.image = UIImage(named: "logout")
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select row: \(indexPath.row)")
        
//        if (indexPath.row == selectedMenuItem) {
//            return
//        }
        setTblCellTintColor(index: selectedMenuItem, isSet: false)
        
        selectedMenuItem = indexPath.row
        setTblCellTintColor(index: selectedMenuItem, isSet: true)
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "home")
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 1:
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "sapList")
        sideMenuController()?.setContentViewController(destViewController)
        break
        case 2:
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "auth")
        sideMenuController()?.setContentViewController(destViewController)
        break
        case 3:
            if numberOfRows == 4 {
                logOut()
            }
            else if numberOfRows == 5 {
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "register")
                sideMenuController()?.setContentViewController(destViewController)
            }
        break
        default:
            logOut()
            break
        }
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return configureProfileView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    func setTblCellTintColor(index:Int, isSet:Bool) {
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .middle)
        var imageName = "custlist"
        if index == 2 {
            imageName = "setting"
        }
        else if index == 3 {
            if numberOfRows == 4 {
                imageName = "logout"
            }
            else if numberOfRows == 5 {
                imageName = "register"
            }
        }
        else if index == 4 {
          imageName = "logout"
        }
        if let myImage = UIImage(named: imageName) {
            var tintImage = myImage.withRenderingMode(.alwaysTemplate)
            if isSet == false {
                tintImage = myImage.withRenderingMode(.alwaysOriginal)
            }
//            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            let indexPath = IndexPath(item: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.imageView?.image = tintImage
            if isSet == true {
                cell?.textLabel?.textColor = UIColor.init(red: 56.0/255.0, green: 147.0/255.0, blue: 246.0/255.0, alpha: 1)
            }
            else {
                cell?.textLabel?.textColor = .darkGray
            }
        }
    }
   
    func configureProfileView() -> UIView {
        var height = 130.0
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            height = 200.0
        }
        
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: CGFloat(height))
        let headerView = UIView(frame: rect)
        headerView.backgroundColor = MangoBlueColor
        let avatar = UIImageView()
        avatar.isUserInteractionEnabled = true
        avatar.tag  = 11
        avatar.image = UIImage(named: "profilePlaceholer")
        avatar.contentMode = .scaleAspectFit
        avatar.frame = CGRect(x: 20, y: 5, width: 70, height: 70)
//        avatar.clipsToBounds = true
//        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        headerView.addSubview(avatar)
        let lblName = UILabel()
        lblName.textColor = .white
        lblName.font = UIFont(name: "Arial", size: 20)
        lblName.frame = CGRect(x: 20, y: 75, width: tableView.frame.size.width, height: 25)
        lblName.textAlignment = .left
        lblName.tag = 2
        lblName.tag  = 12
        headerView.addSubview(lblName)
        
        let lblRole = UILabel()
        lblRole.textColor = .white
        lblRole.font = UIFont(name: "Arial", size: 16)
        lblRole.frame = CGRect(x: 20, y: 100, width: tableView.frame.size.width, height: 20)
        lblRole.textAlignment = .left
        lblRole.tag = 3
        lblRole.tag  = 13
       if let uName = UserDefaults.standard.value(forKey: "USERNAME") as? String {
            lblName.text = uName
        var currentLang = "ES-EN"
        if let selectedLangCode = UserDefaults.standard.value(forKey: "SELECTED_LANG") {
            currentLang = selectedLangCode as! String
        }
        lblRole.text = DatabaseOperation.sharedInstanceOBJ.fetchUserRole(uName: uName,currentLangCode: currentLang)
        }
        headerView.addSubview(lblRole)
        return headerView
    }
    func logOut()  {
        var msg = "Do you want logout"
        var btnYes = "Yes"
        var btnNo = "NO"
//        if let appname = sideMenuViewModel?.AppName {
//            appName = appname
//        }
        if let ms = sideMenuViewModel?.WannaLogout {
            msg = ms
        }
        if let yes = sideMenuViewModel?.Yes {
            btnYes = yes
        }
        if let no = sideMenuViewModel?.No {
            btnNo = no
        }
        let alert = UIAlertController(title: "Mango", message: msg, preferredStyle: .alert)
        let noAction = UIAlertAction(title: btnNo, style: .default, handler: nil)
        let yesAction = UIAlertAction(title: btnYes, style: .default) {[weak self] (alertAction) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "addaccount") as! AddAccountViewController
            //            self?.navigationController?.pushViewController(vc, animated: true)
            self!.selectedMenuItem = 0
            var index = 3
            if self?.numberOfRows == 5 {
                index = 4
            }
            self?.setTblCellTintColor(index: index, isSet: false)
            vc.isNavigationbarNeedToShow = true;
            UserDefaults.standard.removeObject(forKey: "isUserLoggedIn"); self?.sideMenuController()?.sideMenu?.allowPanGesture = false
            self?.sideMenuController()?.sideMenu?.allowLeftSwipe = false; self?.sideMenuController()?.setContentViewController(vc)
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

