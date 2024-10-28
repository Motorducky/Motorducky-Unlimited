import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnHidePassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnGoToSignUP: UIButton!
    @IBOutlet weak var btnForgetPasswrd: UIButton!
    
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
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if validateFields() {
            guard let email = tfEmail.text, let password = tfPassword.text else { return }
     
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.showAlert(message: "Login failed: \(error.localizedDescription)")
                    return
                }
                
              
                self.fetchUserInfo(email: email, password: password)
            }
        }
    }
    
    func fetchUserInfo(email: String, password: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                let storedEmail = userData?["email"] as? String
                let storedPassword = userData?["password"] as? String
                
                
                if storedEmail == email && storedPassword == password {
                    self.showAlert(message: "Login successful!")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            self.navigateToHome()
                                        }
                } else {
                    self.showAlert(message: "Incorrect email or password.")
                }
            } else {
                self.showAlert(message: "No user data found.")
            }
        }
    }
    
    @IBAction func btnGoToSignUP(_ sender: UIButton) {
        navigateToSignUpScreen()
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
        return true
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
             
           })
           present(alert, animated: true, completion: nil)
    }
    
    func setupPasswordToggle() {
        tfPassword.isSecureTextEntry = true
        btnHidePassword.setImage(UIImage(named: "closeEye"), for: .normal)
    }
    
    func navigateToSignUpScreen() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            let navigationController = UINavigationController(rootViewController: homeVC)
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
}
