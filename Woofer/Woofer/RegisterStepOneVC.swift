//
//  RegisterStepOneVC.swift
//  Woofer
//
//  Created by Franco Garza on 5/17/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
// AUTH
import FirebaseAuth
// REALTIME DATABASE
import FirebaseDatabase

// MARK: - Global structures
// can be used in all VCs
struct newUser{
    static var username = String(); static var email = String(); static var firstName = String()
    static var lastName = String(); static var birthdate = String(); static var gender = Bool()
    static var occupation = String(); static var password = String(); static var dogName = String()
    static var dogBirthdate = String(); static var dogBreed = String(); static var dogGender = Bool()
    static var dogExperience = Bool(); static var dogAllergies = Bool(); static var dogVaccinated = Bool()
    static var dogPedigree = Bool(); static var dogPersonality = Bool()
}

let db = Database.database().reference()

// MARK: - ViewController
class RegisterStepOneVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    var userNameExists = false
    
// MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        tf_username.delegate = self
        tf_email.delegate = self
        tf_password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        // aux string
        // clean strings
        let username = (tf_username.text?.trimmingCharacters(in: .whitespacesAndNewlines))! as String
        let email = tf_email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword = tf_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // Check that all fields are filled in
        if  username == "" || email == "" {
            return "Please fill in all fields"
        }
        // check password validity
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
            let username = (tf_username.text?.trimmingCharacters(in: .whitespacesAndNewlines))! as String
            let email = (tf_email.text?.trimmingCharacters(in: .whitespacesAndNewlines))! as String
            let password = (tf_password.text?.trimmingCharacters(in: .whitespacesAndNewlines))! as String
            // check if username exists
            db.child("users/\(username)").observeSingleEvent(of: .value, with: {(snapshot) in
                if (snapshot.exists()){
                    self.showError("username already in use")
                }else{
                    // create cleaned versiond of the data
                    newUser.username = username
                    newUser.email = email
                    newUser.password = password
                    
                    Auth.auth().signIn(withEmail: email, password: " ") { (user, error) in
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            switch errCode {
                                case .wrongPassword:
                                    self.showError("email already in use")
                                case .userNotFound:
                                    self.transitionToNextStep()
                                default:
                                    print("Create User Error: \(error!)")
                            }
                        }
                    }
                }
            })
        }
    }
    
    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func transitionToNextStep(){
        let registerStepTwoVC = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.registerStepTwo))! as RegisterStepTwoVC
        self.present(registerStepTwoVC, animated: true, completion: nil)
    }
    
}
