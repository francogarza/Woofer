//
//  RegisterStepFourVC.swift
//  Woofer
//
//  Created by Franco Garza on 5/17/21.
//

import UIKit
import Firebase

class RegisterStepFourVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func bt_finishRegister(_ sender: UIButton) {
        
        // create user
        Auth.auth().createUser(withEmail: newUser.email, password: newUser.password) { (result, err) in
            // Check for errors
            if err != nil{
                // There was an error creating the user
                self.showError("Invalid email")
            } else{
                // user was created successfully, now store data
                db.collection("users").addDocument(data: ["username":newUser.username, "uid": result!.user.uid]) { (error) in
                    if error != nil {
                        self.showError("Error saving user data")
                    }
                }
            }
        }
        
    }
    

    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
