//
//  HomeViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/18/21.
//

import UIKit
import Firebase
import FirebaseStorage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var dogId: UILabel!
    @IBOutlet weak var bt_dislike: UIButton!
    @IBOutlet weak var bt_like: UIButton!
    @IBOutlet weak var bt_viewProfile: UIButton!
    @IBOutlet weak var lb_age: UILabel!
    @IBOutlet weak var img_dogImage: UIImageView!
    var petsData: [[String:Any]] = [[:]]
    var i = 0
    
    @IBOutlet weak var currentUsername: UILabel!
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set("", forKey: "url")
        loadPet()
        
        let ref = Database.database().reference(withPath: "users")
        ref.queryOrdered(byChild: "uid").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: {snapshot in
            
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                self.currentUsername.text = snap.key
                
            }
            
        })
        
        
    }
    
    @IBAction func bt_like(_ sender: UIButton) {
        
        db.child("users/\(username.text!)/pets/\(dogId.text!)/status/\(Auth.auth().currentUser!.uid)").setValue("like")
        db.child("users/\(currentUsername.text!)/likes/\(username.text!)").setValue("like")
        
        disableButtons()
        loadPet()
        
    }
    
    @IBAction func bt_dislike(_ sender: Any) {
            
        db.child("users/\(username.text!)/pets/\(dogId.text!)/status/\(Auth.auth().currentUser!.uid)").setValue("dislike")

        disableButtons()
        loadPet()
    }
    
    func loadPet(){
        name.text = "name"
        username.text = "username"
        dogId.text = "dogId"
        img_dogImage.image = nil
        
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
                    // create a constant to cast status for the pet
                    let status = petDic["status"] as! [String: Any]
                    // check to see if the pet has been given a status by the user before
                    if status[Auth.auth().currentUser!.uid] == nil{
                        
                        if petDic["ownerUID"] as? String != Auth.auth().currentUser?.uid{
                            self.name.text = petDic["name"] as? String
                            self.username.text = petDic["owner"] as? String
                            self.dogId.text = snapPets.key
                            self.enableButtons()
                            
                            let age = petDic["birthdate"] as? String
                            self.lb_age.text = age
                            
                            // load image
                            let userDic = snapUsers.value as! [String:Any]
                            let email = userDic["email"] as! String
                            
                            self.storage.child("images/\(email).png").downloadURL(completion: {url, error in
                                
                                guard let url = url, error == nil else{
                                    UserDefaults.standard.set("urlString", forKey: "url")
                                    return
                                }
                                
                                let urlString = url.absoluteString
                                print("downaload url: \(urlString)")
                                UserDefaults.standard.set(urlString, forKey: "url")
                                
                                self.loadImage()
                                
                            })
                            
                            return
                        }
                        
                    }
                    
                }
            }
        })
        
        
    }
    
    func loadImage(){
        
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string: urlString) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.sync {
                
                let image = UIImage(data: data)
                self.img_dogImage.image = image
            }
            
        })
        
        task.resume()
    }
    
    func disableButtons(){
        bt_dislike.alpha = 0.25
        bt_dislike.isUserInteractionEnabled = false
        bt_like.alpha = 0.25
        bt_like.isUserInteractionEnabled = false
        bt_viewProfile.alpha = 0.25
        bt_viewProfile.isUserInteractionEnabled = false
    }
    
    func enableButtons(){
        bt_dislike.alpha = 1
        bt_dislike.isUserInteractionEnabled = true
        bt_like.alpha = 1
        bt_like.isUserInteractionEnabled = true
        bt_viewProfile.alpha = 1
        bt_viewProfile.isUserInteractionEnabled = true
    }
    
}
