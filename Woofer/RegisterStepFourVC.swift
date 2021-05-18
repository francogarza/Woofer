//
//  RegisterStepFourVC.swift
//  Woofer
//
//  Created by Franco Garza on 5/17/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterStepFourVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func bt_finishRegister(_ sender: UIButton) {
        
        // Create the user
//        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
//
//            // Check for errors
//            if err != nil {
//
//                // There was an error creating the user
//                self.showError("Error creating user")
//            }
//            else {
//
//                // User was created successfully, now store the first name and last name
//                let db = Firestore.firestore()
//
//                db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid": result!.user.uid ]) { (error) in
//
//                    if error != nil {
//                        // Show error message
//                        self.showError("Error saving user data")
//                    }
//                }
//
//                // Transition to the home screen
//                self.transitionToHome()
//            }
//
//        }
        
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
                        db.child("users/\(newUser.username)/uid").setValue("\(result!.user.uid)")
                    }
                })
                
                // transition to home missing
                
            }
        }
    }
    

    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    

}
