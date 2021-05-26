//
//  SettingsViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/25/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var sw_interest: UISwitch!
    @IBOutlet weak var sw_vaccinated: UISwitch!
    @IBOutlet weak var sw_pedigree: UISwitch!
    @IBOutlet weak var sw_parentalExperience: UISwitch!
    let userdefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
    }
    
    func loadSettings(){
        if(userdefaults.value(forKey: "filterGender") as! String == "male"){
            sw_interest.isOn = true
        }else{
            sw_interest.isOn = false
        }
        if(userdefaults.value(forKey: "filterVaccinated") as! String == "true"){
            sw_vaccinated.isOn = true
        }else{
            sw_vaccinated.isOn = false
        }
        if(userdefaults.value(forKey: "filterPedigree") as! String == "true"){
            sw_pedigree.isOn = true
        }else{
            sw_pedigree.isOn = false
        }
        if(userdefaults.value(forKey: "filterParental") as! String == "true"){
            sw_parentalExperience.isOn = true
        }else{
            sw_parentalExperience.isOn = false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if sw_interest.isOn{
            userdefaults.set("male",forKey: "filterGender")
        }else{
            userdefaults.set("female",forKey: "filterGender")
        }
        if sw_vaccinated.isOn{
            userdefaults.set("true",forKey: "filterVaccinated")
        }else{
            userdefaults.set("false",forKey: "filterVaccinated")
        }
        if sw_pedigree.isOn{
            userdefaults.set("true",forKey: "filterPedigree")
        }else{
            userdefaults.set("false",forKey: "filterPedigree")
        }
        if sw_parentalExperience.isOn{
            userdefaults.set("true",forKey: "filterParental")
        }else{
            userdefaults.set("false",forKey: "filterParental")
        }
    }

}
