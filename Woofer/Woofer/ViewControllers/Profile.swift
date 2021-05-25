//
//  Profile.swift
//  Woofer
//
//  Created by Monica Nava on 25/05/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class Profile: UIViewController{
    @IBOutlet var dogName: UILabel!
    @IBOutlet var profileEmail: UILabel!
    @IBOutlet var dogBreed: UILabel!
    @IBOutlet var dogAge: UILabel!
    
    @IBOutlet var vaccineTagNone: UILabel!
    
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var ownerAge: UILabel!
    @IBOutlet var ownerLastname: UILabel!
    @IBOutlet var occupation: UILabel!
    //subir foto
    //subir foto dueño
    //obtnener edad
    //si esta vacunado esconde el none
    
    private let storage = Storage.storage().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //funciones
        loadProfile()
    }
    func loadProfile(){
        let ref = Database.database().reference(withPath: "users")
        //let usernameIdN  = HomeViewController()
        
        let username = UserDefaults.standard.value(forKey: "currentUsername")
        
        let userID = Auth.auth().currentUser?.uid
        ref.child(username as! String).observeSingleEvent(of: .value, with: {snapshot in // tomar valores
            print(snapshot)
            let userDict = snapshot.value as! [String: Any]
            let userName = userDict["name"] as! String
            let userLastName = userDict["lastName"] as! String
            let userOccupation = userDict["occupation"] as! String
            let userMailn = userDict["email"] as! String
            self.ownerName.text = userName
            self.ownerLastname.text = userLastName
            self.occupation.text = userOccupation
            self.profileEmail.text = userMailn
        })
        
        //del perro
        ref.child(username as! String).child("pets").observeSingleEvent(of: .value, with: {snapshot in
            // tomar valores
            let pets = snapshot.value as! [String: Any]
            let dogDict = pets[pets.startIndex].value as! [String:Any]
            let doguserName = dogDict["name"] as! String
            let doguserBreed = dogDict["breed"] as! String
            self.dogName.text = doguserName
            self.dogBreed.text = doguserBreed
            //vacuna
            //let dogVacDict = snapshot.value
            ///as! [Bool: Any]
           
        })
    }
}
