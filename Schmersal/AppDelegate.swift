
import UIKit
import LocalAuthentication
import Network
import AudioToolbox

let appDelegate = UIApplication.shared.delegate as! AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isInternetAvailable:Bool = false
    lazy var authenticateView = UIView()
    lazy var progressView = CircleLoader.createGeometricLoader()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.statusBarStyle = .lightContent
        DataBaseHandler.sharedInstance.initilizeDatabase()
        Thread.sleep(forTimeInterval: 2)
        checkInternetConnection()
        registerObserverForInternetConnection()
        return true
    }
    func checkInternetConnection()  {
        do {
            try Network.reachability = Reachability(hostname: "www.google.com/")
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
    }
    
    func registerObserverForInternetConnection()  {
        if #available(iOS 12.0, *) {
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                if path.usesInterfaceType(.wifi) {
                    print("It's WiFi!")
                    print("Connected to net")
                } else if path.usesInterfaceType(.cellular) {
                    print("3G/4G FTW!!!")
                    print("Connected to net")
                }
                else {
                    print("No internet connection")
                }
                
                if path.status == .satisfied {
                    print("Connected to net")
                    self.isInternetAvailable = true
//                    self.internetConnectionFound()
                }
                else {
                    print("No internet connection")
                    self.isInternetAvailable = false
                    self.showNoInternetConnectionAlert()
                }
            }
            let queue = DispatchQueue(label: "Monitor")
            monitor.start(queue: queue)
        }
        else {
            NotificationCenter.default.removeObserver((Any).self, name: .flagsChanged, object: nil)
            NotificationCenter.default
                .addObserver(self,
                             selector: #selector(statusManager),
                             name: .flagsChanged,
                             object: nil)
            updateInternetFlag()
        }
    }
    func updateInternetFlag() {
        switch Network.reachability?.status {
        case .unreachable?:
            self.isInternetAvailable = false
            showNoInternetConnectionAlert()
            break
        case .wwan?:
            self.isInternetAvailable = true
//            internetConnectionFound()
            break
        case .wifi?:
            self.isInternetAvailable = true
//            internetConnectionFound()
            break
        case .none:
            self.isInternetAvailable = false
             showNoInternetConnectionAlert()
            break
        }
    }
    @objc func statusManager(_ notification: Notification) {
        updateInternetFlag()
    }
    
    func showNoInternetConnectionAlert() {
        var currentLang = "ES-EN"
        if let selectedLangCode = UserDefaults.standard.value(forKey: "SELECTED_LANG") {
            currentLang = selectedLangCode as! String
        }
        showToast(message:getText(key: "key_internet", langCode: currentLang))
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        if UserDefaults.standard.value(forKey: "isTouchEnabled") != nil {
            authWithTouchId()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func authWithTouchId() {
        DispatchQueue.main.async {
            if self.window?.viewWithTag(5) == nil {
                if let frame = self.window?.frame {
                    self.authenticateView.frame = frame
                }
                self.authenticateView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                self.authenticateView.tag = 5
                self.window?.addSubview(self.authenticateView)
            }
        }
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with TouchID/FaceID"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply:
                {(success, error) in
                    if success {
                        DispatchQueue.main.async {
                            print("Authenticated")
                            NotificationCenter.default.post(name: Notification.Name("USERAUTHENTICATION"), object: true)
                            self.authenticateView.removeFromSuperview()
                        }
                    }
                    else {
                        var message :String = ""
                        if let error = error {
                            switch(error.self) {
                            case LAError.authenticationFailed:
                                message = "There was a problem verifying your identity."
                                self.authenticateView.removeFromSuperview()
                            case LAError.userCancel:
                                message = "User pressed cancel."
                                self.authWithTouchId()
                            case LAError.userFallback:
                                message = "User pressed password."
                                self.authenticateView.removeFromSuperview()
                            default:
                                message = "Touch ID may not be configured/Locked"
                                self.authenticateView.removeFromSuperview()
                            }
                            print(message)
                        }
                        DispatchQueue.main.async {
                            print("Authentication Failed")
                            NotificationCenter.default.post(name: Notification.Name("USERAUTHENTICATION"), object: false)
                            
                        }
                    }
            })
        }
        else {
            var errorMsg = "TouchID/FaceID is not registered"
            if error?.code == Int(kLAErrorBiometryNotAvailable) {
                errorMsg = "TouchID/FaceID is not available"
            }
            
            if error?.code == Int(kLAErrorBiometryNotEnrolled) {
                errorMsg = "TouchID/FaceID is not enrolled"
            }
            
            if error?.code == Int(kLAErrorBiometryLockout) {
                errorMsg = "Locked out"
            }
            NotificationCenter.default.post(name: Notification.Name("USERAUTHENTICATION"), object: false)
            self.authenticateView.removeFromSuperview()
            showToast(message: errorMsg)
        }
    }
    
    func getText(key:String, langCode:String) -> String {
        return DatabaseOperation.sharedInstanceOBJ.fetchValueForKey(key: key, langCode: langCode)
    }
}

extension AppDelegate {

    func showToast(message : String) {
        DispatchQueue.main.async {
            guard let window = self.window else {
                return
            }
            let toastLabel = UILabel(frame: CGRect(x: 20, y: window.frame.size.height - (window.safeAreaInsets.bottom + 50), width: window.frame.size.width - 40, height: 40))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.font = UIFont(name: "Arial", size: 14)
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.numberOfLines = 0
            toastLabel.layer.cornerRadius = 7;
            toastLabel.clipsToBounds  =  true
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            window.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
}
