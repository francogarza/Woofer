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
    @IBOutlet weak var bt_dislike: UIButton!
    @IBOutlet weak var bt_like: UIButton!
    @IBOutlet weak var bt_viewProfile: UIButton!
    @IBOutlet weak var lb_age: UILabel!
    @IBOutlet weak var img_dogImage: UIImageView!
    @IBOutlet weak var section: UIView!
    var i = 0
    
    var currentUsernameString: String!

    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultFilters()
        
        UserDefaults.standard.set("", forKey: "urlDogImageBrowse")
        loadPet()
        
        let ref = Database.database().reference(withPath: "users")
        ref.queryOrdered(byChild: "uid").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: {snapshot in
            
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                UserDefaults.standard.set(snap.key, forKey: "currentUsername")
                
            }
            
        })
        currentUsernameString = UserDefaults.standard.value(forKey: "currentUsername") as? String
        
        img_dogImage.contentMode = .scaleAspectFill
        img_dogImage.layer.borderWidth = 5
        img_dogImage.layer.borderColor = UIColor(named: "black")?.cgColor
        
        section.layer.borderWidth = 3
        section.layer.borderColor = UIColor(named: "black")?.cgColor
        
        bt_viewProfile.layer.cornerRadius = 20
        bt_viewProfile.clipsToBounds = true
        bt_viewProfile.layer.borderColor = UIColor(named: "black")?.cgColor
        bt_viewProfile.layer.borderWidth = 3
        
        bt_like.clipsToBounds = true
        bt_like.layer.cornerRadius = 40
        bt_like.layer.borderColor = UIColor(named: "black")?.cgColor
        bt_like.layer.borderWidth = 3
        
        bt_dislike.clipsToBounds = true
        bt_dislike.layer.cornerRadius = 40
        bt_dislike.layer.borderColor = UIColor(named: "black")?.cgColor
        bt_dislike.layer.borderWidth = 3
        
        disableButtons()
        
    }
    
    
    @IBAction func bt_like(_ sender: UIButton) {
        
        let username = UserDefaults.standard.value(forKey: "browseUsername")
        let dogId = UserDefaults.standard.value(forKey: "browseDogId")
        
        db.child("users/\(username!)/pets/\(dogId!)/status/\(Auth.auth().currentUser!.uid)").setValue("like")
        db.child("users/\(currentUsernameString!)/likes/\(username!)").setValue("like")
        
        disableButtons()
        loadPet()
        
    }
    
    @IBAction func bt_dislike(_ sender: Any) {
        
        let username = UserDefaults.standard.value(forKey: "browseUsername")
        let dogId = UserDefaults.standard.value(forKey: "browseDogId")
        db.child("users/\(username!)/pets/\(dogId!)/status/\(Auth.auth().currentUser!.uid)").setValue("dislike")

        disableButtons()
        loadPet()
    }
    
    func loadPet(){
        img_dogImage.image = UIImage(named: "gallery-2")
        
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
                            UserDefaults.standard.set(petDic["owner"], forKey: "browseUsername")
                            UserDefaults.standard.set(snapPets.key, forKey: "browseDogId")
                            self.enableButtons()
                            let age = petDic["birthdate"] as? String
                            self.lb_age.text = "\(self.getYears(birthdate: age)) years old"
                            // load image
                            let userDic = snapUsers.value as! [String:Any]
                            let email = userDic["email"] as! String
                            self.storage.child("images/\(email)dog.png").downloadURL(completion: {url, error in
                                guard let url = url, error == nil else{
                                    UserDefaults.standard.set("urlString", forKey: "urlDogImageBrowse")
                                    return
                                }
                                let urlString = url.absoluteString
                                // set it as user default so load image can use this value
                                UserDefaults.standard.set(urlString, forKey: "urlDogImageBrowse")
                                self.loadImage()
                            })
                            return
                        }
                    }
                    
                }
            }
        })
    }
    
    func getYears(birthdate: String!) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let date = dateFormatter.date(from:birthdate)
        let now = Date()
        let birthday = date
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
        let age = ageComponents.year!
        
        return age
    }
    
    func loadImage(){
        guard let urlString = UserDefaults.standard.value(forKey: "urlDogImageBrowse") as? String,
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
    
    func setDefaultFilters(){
        let userdefaults = UserDefaults.standard
        if(userdefaults.value(forKey: "filterGender") == nil){
            userdefaults.set("male",forKey: "filterGender")
            userdefaults.set("true",forKey: "filterVaccinated")
            userdefaults.set("true",forKey: "filterPedigree")
            userdefaults.set("true",forKey: "filterParental")
        }
    }
    
    func disableButtons(){
        bt_dislike.alpha = 0.25
        bt_dislike.isUserInteractionEnabled = false
        bt_like.alpha = 0.25
        bt_like.isUserInteractionEnabled = false
        bt_viewProfile.alpha = 0.25
        bt_viewProfile.isUserInteractionEnabled = false
        lb_age.text = "no more pets available"
        lb_age.textAlignment = .center
        name.text = ""
        
    }
    
    func enableButtons(){
        bt_dislike.alpha = 1
        bt_dislike.isUserInteractionEnabled = true
        bt_like.alpha = 1
        bt_like.isUserInteractionEnabled = true
        bt_viewProfile.alpha = 1
        bt_viewProfile.isUserInteractionEnabled = true
        lb_age.textAlignment = .right
    }
    
}
