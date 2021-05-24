//
//  HomeViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/18/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var dogId: UILabel!
    var petsData: [[String:Any]] = [[:]]
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPet()
        
        
    }
    
    @IBAction func bt_like(_ sender: UIButton) {
        
        db.child("users/\(username.text!)/pets/\(dogId.text!)/status/\(Auth.auth().currentUser!.uid)").setValue("like")
        
    }
    
    
    func loadPet(){
        // get the reference for the users
        let ref = Database.database().reference(withPath: "users")
        // get the snapshot of these reference
        ref.observeSingleEvent(of: .value, with: { snapshot in
            // check if snapshot exists
            if !snapshot.exists() { return }
            // loop through its children
            for childUser in snapshot.children{
                // create a constant to cast each child(user) as a DataSnapshot
                let snapUsers = childUser as! DataSnapshot
                // create a constant to cast the snapshot of the pets of the user
                let pets = snapUsers.childSnapshot(forPath: "pets")
                // loop through the children in the snapshot of the user's pets
                for childPets in pets.children{
                    // create a constant to cast each child(pet) as a DataSnapshot
                    let snapPets = childPets as! DataSnapshot
                    // create a constant to cast snapPets as a dictionary
                    let petDic = snapPets.value as! [String: Any]
                    let status = petDic["status"] as! [String: Any]
                    
                    if let contains = status[Auth.auth().currentUser!.uid]{
                        // do nothing
                    }else {
                        if petDic["ownerUID"] as? String == Auth.auth().currentUser?.uid{
                            
                        }else{
                            self.name.text = petDic["name"] as? String
                            self.username.text = petDic["owner"] as? String
                            self.dogId.text = snapPets.key
                            return
                        }
                    }
                    
                    // copy the dictionary to the array of dictionaries we created to store all pets data
                    self.petsData.append(petDic)
                    // print test
                    print(self.petsData[self.i])
                    // increment iterator
                    self.i += 1
                }
            }
        })
    }
    
}
