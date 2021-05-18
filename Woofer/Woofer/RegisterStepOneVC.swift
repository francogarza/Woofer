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

struct newUser{
    
    static var username = String()
    static var email = String()
    static var firstName = String()
    static var lastName = String()
    static var birthdate = String()
    static var gender = Bool()
    static var occupation = String()
    static var password = String()
    static var dogName = String()
    static var dogBirthdate = Date()
    static var dogBreed = String()
    static var dogGender = Bool()
    static var dogExperience = Bool()
    static var dogAllergies = Bool()
    static var dogVaccinated = Bool()
    static var dogPedigree = Bool()
    static var dogPersonality = Bool()
    
}


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
            newUser.username = tf_username.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            newUser.email = tf_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            newUser.password = tf_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //check email already exist or not.
            Auth.auth().fetchSignInMethods(forEmail: newUser.email) { (providers, error) in
                if providers != nil{
                    self.showError("email already in use")
                }else {
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
        self.present(registerStepTwoVC, animated: true, completion: nil)
    }
}
