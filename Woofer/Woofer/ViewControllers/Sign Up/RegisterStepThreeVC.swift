//
//  RegisterStepThreeVC.swift
//  Woofer
//
//  Created by Franco Garza on 5/17/21.
//

import UIKit
import DLRadioButton
import FirebaseStorage

class RegisterStepThreeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var username = String()
    var dogName = String()
    
    private let storage = Storage.storage().reference()
    
    @IBOutlet weak var radBt_allergies: DLRadioButton!
    @IBOutlet weak var radBt_vaccinated: DLRadioButton!
    @IBOutlet weak var radBt_Pedigree: DLRadioButton!
    @IBOutlet weak var radBt_personality: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if (radBt_allergies.isSelected == false && radBt_allergies.otherButtons[0].isSelected == false) ||
           (radBt_vaccinated.isSelected == false && radBt_vaccinated.otherButtons[0].isSelected == false) ||
           (radBt_Pedigree.isSelected == false && radBt_Pedigree.otherButtons[0].isSelected == false) ||
           (radBt_personality.isSelected == false && radBt_personality.otherButtons[0].isSelected == false){
            return "Please fill in all fields"
        }
        return nil
    }
    
    @IBAction func bt_uploadImage(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageData = image.pngData() else{
            return
        }
        
        
        storage.child("images/\(newUser.email)dog.png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else{
                print("failse to upload")
                return
            }
            
            
        })
        
        // up;oad image
        //get downlaod url
        // save download url
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bt_registerStepThree(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else{
            // create cleaned versiond of the data
            newUser.dogAllergies = radBt_allergies.isSelected
            newUser.dogVaccinated = radBt_vaccinated.isSelected
            newUser.dogPedigree = radBt_Pedigree.isSelected
            newUser.dogPersonality = radBt_personality.isSelected
            
            let registerStepFourVC = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.registerStepFour))! as RegisterStepFourVC
            self.present(registerStepFourVC, animated: true, completion: nil)
        }
    }
    
    
    
    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
