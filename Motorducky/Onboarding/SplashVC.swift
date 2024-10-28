//
//  SplashVC.swift
//  Motorducky
//
//  Created by Rizwan on 21/10/2024.
//
import UIKit
import FirebaseAuth

class SplashVC: UIViewController {

    @IBOutlet weak var bgImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "splash")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(checkLoginStatus), userInfo: nil, repeats: false)
    }

    @objc func checkLoginStatus() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        var nextViewController: UIViewController
        if Auth.auth().currentUser != nil {
            nextViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        } else {
            nextViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        }
        
      
        let navigationController = UINavigationController(rootViewController: nextViewController)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}
