//
//  RegisterStepTwoVC.swift
//  Woofer
//
//  Created by Franco Garza on 5/17/21.
//

import UIKit
// Radio buttons library
import DLRadioButton

class RegisterStepTwoVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf_dogName: UITextField!
    @IBOutlet weak var date_dogBirthdate: UIDatePicker!
    @IBOutlet weak var tf_dogBreed: UITextField!
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        date_dogBirthdate.datePickerMode = .date
        
            
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        tf_dogName.delegate = self
        tf_dogBreed.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if  tf_dogName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tf_dogBreed.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || dateFormatter.string(from: date_dogBirthdate.date) == dateFormatter.string(from: Date()){
            return "Please fill in all fields"
        }
        return nil
    }
    
    @IBAction func bt_registerStepTwo(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else{
            // create cleaned versiond of the data
            newUser.dogName = tf_dogName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            newUser.dogBreed = tf_dogBreed.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            newUser.dogBirthdate = dateFormatter.string(from: date_dogBirthdate.date)
            print(newUser.dogBirthdate)
            
            let registerStepThreeVC = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.registerStepThree))! as RegisterStepThreeVC
            self.present(registerStepThreeVC, animated: true, completion: nil)
            
            
        }
    }
    
    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
