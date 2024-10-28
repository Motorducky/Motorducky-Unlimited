//
//  SignUpViewController.swift
//  Motorducky
//
//  Created by Rizwan on 21/10/2024.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore
class SignUpViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnHidePassword: UIButton!
    @IBOutlet weak var btnGoToLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var tfUserName: UITextField!
    
    var isPasswordHidden: Bool = true
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        setupPasswordToggle()
    }
    
    @IBAction func btnHidePassword(_ sender: UIButton) {
        isPasswordHidden.toggle()
               tfPassword.isSecureTextEntry = isPasswordHidden
               let imageName = isPasswordHidden ? "closeEye" : "openEye"
               btnHidePassword.setImage(UIImage(named: imageName), for: .normal)

        
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        if validateFields() {
            guard let email = tfEmail.text, let password = tfPassword.text, let userName = tfUserName.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                    return
                }
                
                authResult?.user.sendEmailVerification(completion: { error in
                    if let error = error {
                        self.showAlert(message: "Failed to send verification email: \(error.localizedDescription)")
                        return
                    }
                    self.saveUserInfoToFirestore(email: email, userName: userName, password: password)
                    self.navigateToOTPVerification(email: email)
                })
            }
        }
    }
    func saveUserInfoToFirestore(email: String, userName: String, password: String) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            //data modle
            let userData: [String: Any] = [
                "email": email,
                "name": userName,
                "password": password,
                "uid": uid
            ]
            
            // Save user data in the "users" collection
            db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    self.showAlert(message: "Failed to save user info: \(error.localizedDescription)")
                } else {
                    print("User info saved successfully in Firestore")
                }
            }
        }
    @IBAction func btnGoToLogin(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    func navigateToOTPVerification(email: String) {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let otpVC = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
            otpVC.email = email
            self.navigationController?.pushViewController(otpVC, animated: true)
        }
    }
    
    func validateFields() -> Bool {
        guard let email = tfEmail.text, !email.isEmpty else {
            showAlert(message: "Email cannot be empty")
            return false
        }
        guard let password = tfPassword.text, !password.isEmpty else {
            showAlert(message: "Password cannot be empty")
            return false
        }
        guard let userName = tfUserName.text, !userName.isEmpty else {
                    showAlert(message: "Name cannot be empty")
                    return false
                }
        guard isValidPassword(password) else {
            showAlert(message: "Password must be at least 6 characters, contain one letter, one number, and one special character.")
            return false
        }
        return true
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*]).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupPasswordToggle() {
            tfPassword.isSecureTextEntry = true
            btnHidePassword.setImage(UIImage(named: "closeEye"), for: .normal)
        }
}
