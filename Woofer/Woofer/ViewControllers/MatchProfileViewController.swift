//
//  MatchProfileViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/25/21.
//

import UIKit
import Firebase

class MatchProfileViewController: UIViewController {
    
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_breed: UILabel!
    @IBOutlet weak var lb_age: UILabel!
    @IBOutlet weak var img_dogImage: UIImageView!
    @IBOutlet weak var lb_ownerName: UILabel!
    @IBOutlet weak var lb_ownerAge: UILabel!
    @IBOutlet weak var lb_ownerOccupation: UILabel!
    
    
    let matchUsernameString = UserDefaults.standard.value(forKey: "browseUsername") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUsernameString = getCurrentUsername()
        loadInfo()
    }
    
    func loadInfo(){
        // get the reference for the users
        let ref = Database.database().reference(withPath: "users")
        // get the snapshot of these reference
        ref.observeSingleEvent(of: .value, with: { snapshot in
            // check if snapshot exists
            if !snapshot.exists() { return }
            // make a dicitonary out of the snapshot
            let usersDic = snapshot.value as! [String:Any]
            // make a dicitonary out of the match's values
            let matchOwnerDic = usersDic[self.matchUsernameString] as! [String:Any]
            // make a dictionary out of the pet
            let pets = matchOwnerDic["pets"] as! [String:Any]
            let dogDic = pets[pets.startIndex].value as! [String:Any]
            // extract dog data
            self.lb_name.text = dogDic["name"] as? String
            self.lb_breed.text = "Breed: \(dogDic["breed"] as! String)"
            self.lb_age.text = "Age: \(self.getYears(birthdate: dogDic["birthdate"] as? String)) years old"
            self.loadImage()
            // extract owner data
            self.lb_ownerName.text = "Name: \(matchOwnerDic["name"]!) \(matchOwnerDic["lastName"]!)"
            self.lb_ownerAge.text = "Age: \(self.getYears(birthdate: matchOwnerDic["birthdate"] as? String)) years old"
            self.lb_ownerOccupation.text = "Occupation: \(matchOwnerDic["occupation"]!)"
            
        })
    }
    
    func getCurrentUsername() -> String{
        let ref = Database.database().reference(withPath: "users")
        ref.queryOrdered(byChild: "uid").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                UserDefaults.standard.set(snap.key, forKey: "currentUsername")
            }
        })
        return UserDefaults.standard.value(forKey: "currentUsername") as! String
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
    
}
