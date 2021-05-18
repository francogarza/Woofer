//
//  LoginViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/18/21.
//

import UIKit
import Firebase

struct currentUser{
    
    static var uid = String()
    
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tf_email.delegate = self
        tf_password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func loginTapped(_ sender: UIButton) {
        
        // TODO: Validate textfields
        
        // Create cleaned versions of the text field
        let email = tf_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tf_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .userNotFound:
                            self.showError("invalid email")
                        case .wrongPassword:
                            self.showError("wrong password")
                        default:
                            print("Create User Error: \(error!)")
                    }
                }
            }else {
                currentUser.uid = result!.user.uid
                self.transitionToHome()
            }
        }
    }
    
    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func transitionToHome(){
        let homeVC = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeVC))! as HomeViewController
        self.view.window?.rootViewController = homeVC
        self.view.window?.makeKeyAndVisible()
    }
}
