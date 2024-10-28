//
//  OTPViewController.swift
//  Motorducky
//
//  Created by Rizwan on 21/10/2024.
//
import UIKit
import FirebaseAuth

class OTPViewController: UIViewController {

    @IBOutlet weak var btnConfirmOTP: UIButton!
    @IBOutlet weak var tfOTP: UITextField!
    @IBOutlet weak var btnResendOTP: UIButton!
    
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
          }
    
    @IBAction func btnConfirmOTP(_ sender: UIButton) {
        // Confirm OTP
        guard let user = Auth.auth().currentUser else {
            self.showAlert(message: "No user found")
            return
        }
        
        // Reload for latest verification status
        user.reload { error in
            if let error = error {
                self.showAlert(message: "Error occurred: \(error.localizedDescription)")
                return
            }
            
            if user.isEmailVerified {
                self.showAlert(message: "Email verified successfully!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.navigateToLoginScreen()
                }
            } else {
                self.showAlert(message: "The OTP is incorrect or the email is not verified yet.")
            }
        }
    }
    
    @IBAction func btnResendOTP(_ sender: UIButton) {
        // Resend the OTP 
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if let error = error {
                self.showAlert(message: "Failed to resend verification email: \(error.localizedDescription)")
                return
            }
            self.showAlert(message: "Verification email has been resent.")
        })
    }
    
    func navigateToLoginScreen() {
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
