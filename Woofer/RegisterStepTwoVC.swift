//
//  RegisterStepTwoVC.swift
//  Woofer
//
//  Created by Franco Garza on 5/17/21.
//

import UIKit
import DLRadioButton

class RegisterStepTwoVC: UIViewController {

    var username = String()
    var email = String()
    var password = String()
    @IBOutlet weak var tf_dogName: UITextField!
    @IBOutlet weak var date_dogBirthdate: UIDatePicker!
    @IBOutlet weak var tf_dogBreed: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(username)

//        self.isModalInPresentation = true
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func bt_registerStepThree(_ sender: Any) {
        let registerStepThreeVC = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.registerStepThree))! as RegisterStepThreeVC
        registerStepThreeVC.username = username
        registerStepThreeVC.dogName = tf_dogName.text!
        self.present(registerStepThreeVC, animated: true, completion: nil)
    }
    

}
