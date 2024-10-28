import UIKit

class ApplicationRoot: NSObject {
    
    static let shared = ApplicationRoot()
    
    fileprivate let appDelegate = AppDelegate.shared
    
    override init() {
        super.init()
        self.setupAppearance()
    }
    
    fileprivate func setupAppearance() {
        let generalAppearance = UINavigationBar.appearance()
        generalAppearance.clipsToBounds = false
        generalAppearance.setBackgroundImage(UIImage(), for: .default)
        generalAppearance.shadowImage = UIImage()
        generalAppearance.isTranslucent = true
    }
    
    func setupRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "SettingsVC") as! SettingsVC
        let navigationViewController = AppNavigationController.init()
        navigationViewController.viewControllers = [vc]
        navigationViewController.isNavigationBarHidden = true
        AppDelegate.shared.appNavigation = navigationViewController
        AppDelegate.shared.window?.rootViewController = navigationViewController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
}

extension ApplicationRoot {
    @objc func didUserLogOut() {
        NSLog("AppRoot->didUserLogOut")
        DispatchQueue.main.async {
//            let controller = StartFactory.shared.createModule()
//            let navigationViewController = AppNavigationController.init()
//            navigationViewController.viewControllers = [controller]
//            self.appDelegate.window?.rootViewController = navigationViewController
        }
    }
}
