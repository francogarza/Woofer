//
//  RegisterStepOneVC.swift
//  Woofer
//
//  Created by Franco Garza on 5/17/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class RegisterStepOneVC: UIViewController {
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        // Check that all fields are filled in
        if  tf_username.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tf_email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        // check password validity
        let cleanedPassword = tf_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        return nil
    }
    
    @IBAction func bt_registerStepOne(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else{
            // create cleaned versiond of the data
            let username = tf_username.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = tf_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tf_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if err != nil{
                    // There was an error creating the user
                    self.showError("Invalid email")
                } else{
                    // user was created successfully, now store data
                    db.collection("users").addDocument(data: ["username":username, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                    }
                    self.transitionToNextStep()
                }
            }
        }
    }
    
    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func transitionToNextStep(){
        let registerStepTwoVC = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.registerStepTwo))! as RegisterStepTwoVC
        registerStepTwoVC.username = tf_username.text!
        self.present(registerStepTwoVC, animated: true, completion: nil)
    }
}
