

import UIKit
protocol APICallBackProtocol {
    func callBackOfAPI(isUserLoggedIn: Bool)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewPwd: UIView!
    
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUname: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var btnLanguage: UIButton!
    var isInitialView = true
    var isNavigationbarNeedToShow = true
    var selectedLangCode = "ES-EN"
    var viewModel : LoginLanguageViewModel?
    var dropDownViewModel:DropDownView?
    var km:KeyboardManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 3
        viewBorder.layer.cornerRadius = 5
        viewBorder.layer.borderWidth = 1
        viewBorder.layer.borderColor = MangoBlueColor.cgColor
        isUserAlreadyLoggedIn()
        setStatusbarColor()
        getLanguages()
    }
    
    func setStatusbarColor()  {
        StatusBar.sharedInstanceOBJ.setStatusbarColor(v: self.view)
        self.navigationController?.navigationBar.barTintColor = MangoBlueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = isNavigationbarNeedToShow
        renderUI()
        km = KeyboardManager()
        km?.registerObserver(vController: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        setUpDropDown()
    }
    override func viewDidDisappear(_ animated: Bool) {
           km?.removeObserver()
       }
    func isUserAlreadyLoggedIn()  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if (UserDefaults.standard.value(forKey: "USERNAME") != nil && UserDefaults.standard.value(forKey: "isUserLoggedIn") != nil ) && isInitialView == true {
            let vc = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (UserDefaults.standard.value(forKey: "USERNAME") != nil && UserDefaults.standard.value(forKey: "isUserLoggedIn") == nil ) && isInitialView == true {
            let vc = storyBoard.instantiateViewController(withIdentifier: "addaccount") as! AddAccountViewController
            vc.isNavigationbarNeedToShow = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func getLogin(_ sender: UIButton) {
        view.endEditing(true)
        let uName = (self.view.viewWithTag(1) as! UITextField).text
        let pwd = (self.view.viewWithTag(2) as! UITextField).text
        
        if uName == "" || pwd == "" {
            showAlert()
            return
        }
        if appDelegate.isInternetAvailable == true {
            let apiCall = APICalls()
            apiCall.apiDelegate = self
               apiCall.loginUSER(uname: uName!, pwd: pwd!, langCode: selectedLangCode)
           }
        else {
            showNoInternetConnectionAlert()
        }
    }
    
    func getLanguages() {
        viewModel = LoginLanguageViewModel(selectedLang: selectedLangCode)
    }
    func renderUI()  {
        if let placeholder = viewModel?.uNamePlaceholder {
            txtUname.placeholder = placeholder
        }
        if let placeholder = viewModel?.pwdPlaceholder {
            txtPwd.placeholder = placeholder
        }
        if let btnLangTitle = viewModel?.selectLanguage {
            btnLanguage.setTitle(btnLangTitle, for: .normal)
        }
        if let btnLoginTitle = viewModel?.btnLogin {
            btnLogin.setTitle(btnLoginTitle, for: .normal)
        }
    }
    
    @IBAction func showDropDown(_ sender: UIButton) {
        dropDownViewModel?.showDropDown(sender)
    }
    
    func setUpDropDown() {
        dropDownViewModel = DropDownView(dataArray: viewModel!.langArray as NSArray, tag: 1, vc: self, langCode: selectedLangCode)
        dropDownViewModel?.delegate = self
        dropDownViewModel?.setUpDropDown(frame: btnLanguage.frame)
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
extension ViewController: DropDownViewProtocol{
    func selectedItemInDropDown(value: Any, tag:Int) {
        if tag == 1 {
            let langModel = (value as! LanguageModel)
            selectedLangCode = langModel.languageCode
            viewModel?.selectedLanguage = langModel.languageCode
            btnLanguage.setTitle(selectedLangCode, for: .normal)
            renderUI()
        }
    }
}
extension ViewController {
    func showAlert() {
        appDelegate.showToast(message: appDelegate.getText(key: "key_wrong_credential_msg", langCode: selectedLangCode))
    }
    func showNoInternetConnectionAlert() {
        appDelegate.showToast(message:appDelegate.getText(key: "key_internet", langCode: selectedLangCode))
    }
}


extension ViewController: APICallBackProtocol {
    func callBackOfAPI(isUserLoggedIn: Bool) {
        DispatchQueue.main.async {
            if isUserLoggedIn == true {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                appDelegate.showToast(message: appDelegate.getText(key: "key_login_error", langCode: self.selectedLangCode))
            }
        }
    }
}
