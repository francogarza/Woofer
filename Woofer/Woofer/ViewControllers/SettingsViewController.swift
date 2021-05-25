//
//  SettingsViewController.swift
//  Woofer
//
//  Created by Diego Villarreal on 25/05/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var GenderSwitch: UISwitch!
    @IBOutlet weak var VaccinatedSwitch: UISwitch!
    @IBOutlet weak var PedigreeSwitch: UISwitch!
    @IBOutlet weak var ParExpSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadValues()
        
        
    }
    
    @IBAction func SettingOfGender(_ sender: UISwitch) {
        if (sender.isOn == true){
            
        }
        else{
            
        }
    }
    
    @IBAction func SettingOfVaccinated(_ sender: UISwitch) {
        if (sender.isOn == true){
            
        }
        else{
            
        }
    }
    
    @IBAction func SettingOfPedigree(_ sender: UISwitch) {
        if (sender.isOn == true){
            
        }
        else{
            
        }
    }
    
    @IBAction func SettingOfParentalExperience(_ sender: UISwitch) {
        if (sender.isOn == true){
            
        }
        else{
            
        }
    }
    
    func loadValues(){
        
        
        
        
    }
    
}
