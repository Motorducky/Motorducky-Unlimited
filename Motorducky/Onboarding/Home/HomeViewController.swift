//
//  HomeViewController.swift
//  Motorducky
//
//  Created by Rizwan on 21/10/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    let db = Firestore.firestore()
    
    @IBAction func btnLogout(_ sender: UIButton) {
        do {
                   try Auth.auth().signOut()
                   navigateToLoginScreen()
               } catch let signOutError as NSError {
                   showAlert(message: "Error signing out: \(signOutError.localizedDescription)")
               }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
       
        getUserName()
    }
    
    // Fetch user name from Firestore
    func getUserName() {
        // check user is logdin or not
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        // Get data from firestore
        db.collection("users").document(uid).getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            
            if let document = document, document.exists {
               
                let data = document.data()
                let userName = data?["name"] as? String ?? "User"
                
             
                self.lblUserName.text = "\(userName)😊"
            } else {
                print("User document does not exist")
            }
        }
    }
    func navigateToLoginScreen() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
               self.navigationController?.setViewControllers([loginVC], animated: true)
           }
       }
       
       func showAlert(message: String) {
           let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
}
