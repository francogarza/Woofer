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
import DLRadioButton

class RegisterStepFourVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf_firstName: UITextField!
    @IBOutlet weak var tf_lastName: UITextField!
    @IBOutlet weak var date_birthDate: UIDatePicker!
    @IBOutlet weak var radbt_gender: DLRadioButton!
    @IBOutlet weak var tf_occupation: UITextField!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        date_birthDate.datePickerMode = .date
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        tf_firstName.delegate = self
        tf_lastName.delegate = self
        tf_occupation.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if  tf_firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tf_lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tf_occupation.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dateFormatter.string(from: date_birthDate.date) == dateFormatter.string(from: Date()) ||
            (radbt_gender.isSelected == false && radbt_gender.otherButtons[0].isSelected == false){
            return "Please fill in all fields"
        }
        return nil
    }
    
    @IBAction func bt_finishRegister(_ sender: UIButton) {
        
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else{
            // create cleaned versiond of the data
            newUser.firstName = tf_firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            newUser.lastName = tf_lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            newUser.occupation = tf_occupation.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            newUser.birthdate = dateFormatter.string(from: date_birthDate.date)
 
            if radbt_gender.isSelected == true{
                newUser.dogGender = "male"
            } else{
                newUser.dogGender = "female"
            }
        
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
                            // CREATE USER
                            db.child("users/\(newUser.username)/email").setValue("\(newUser.email)")
                            db.child("users/\(newUser.username)/name").setValue("\(newUser.firstName)")
                            db.child("users/\(newUser.username)/lastName").setValue("\(newUser.lastName)")
                            db.child("users/\(newUser.username)/birthdate").setValue("\(newUser.birthdate)")
                            db.child("users/\(newUser.username)/gender").setValue("\(newUser.gender)")
                            db.child("users/\(newUser.username)/occupation").setValue("\(newUser.occupation)")
                            db.child("users/\(newUser.username)/pets").setValue("\(newUser.dogName)")
                            db.child("users/\(newUser.username)/pets/\(newUser.dogName)/birthdate").setValue("\(newUser.dogBirthdate)")
                            db.child("users/\(newUser.username)/pets/\(newUser.dogName)/breed").setValue("\(newUser.dogBreed)")
                            db.child("users/\(newUser.username)/pets/\(newUser.dogName)/gender").setValue("\(newUser.dogGender)")
                            db.child("users/\(newUser.username)/pets/\(newUser.dogName)/experience").setValue("\(newUser.dogExperience)")
                            db.child("users/\(newUser.username)/pets/\(newUser.dogName)/allergies").setValue("\(newUser.dogAllergies)")
                            db.child("users/\(newUser.username)/pets/\(newUser.dogName)/vaccinated").setValue("\(newUser.dogVaccinated)")
                            db.child("users/\(newUser.username)/pets/\(newUser.dogName)/pedigree").setValue("\(newUser.dogPedigree)")
                            db.child("users/\(newUser.username)/pets/\(newUser.dogName)/personality").setValue("\(newUser.dogPersonality)")
                            db.child("users/\(newUser.username)/uid").setValue("\(result!.user.uid)")
                        }
                    })
                    currentUser.uid = result!.user.uid
                    self.transitionToHome()
                }
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
