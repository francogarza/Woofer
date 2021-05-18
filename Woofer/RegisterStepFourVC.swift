//
//  RegisterStepFourVC.swift
//  Woofer
//
//  Created by Franco Garza on 5/17/21.
//

import UIKit
import Firebase
import FirebaseDatabase

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
                db.child("users/\(newUser.username)").observeSingleEvent(of: .value, with: {(snapshot) in
                    if (snapshot.exists()){
                        print("user name exists")
                    } else {
                        db.child("users/\(newUser.username)/name").setValue("\(newUser.firstName)")
                    }
                })
            }
        }
    }
    

    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
