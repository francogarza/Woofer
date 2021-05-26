//
//  MyProfileViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/25/21.
//

import UIKit
import Firebase
import FirebaseStorage

class MyProfileViewController: UIViewController {

    @IBOutlet weak var img_dogImage: UIImageView!
    @IBOutlet weak var lb_dogName: UILabel!
    @IBOutlet weak var lb_dogBreed: UILabel!
    @IBOutlet weak var lb_dogAge: UILabel!
    
    @IBOutlet weak var lb_ownerName: UILabel!
    @IBOutlet weak var lb_ownerAge: UILabel!
    @IBOutlet weak var lb_ownerOccupation: UILabel!
    @IBOutlet weak var lb_email: UILabel!
    
    @IBOutlet weak var img_energetic: UIImageView!
    @IBOutlet weak var img_parental: UIImageView!
    @IBOutlet weak var img_vaccinated: UIImageView!
    
    let currentUsernameString = UserDefaults.standard.value(forKey: "currentUsername") as! String
    
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img_dogImage.contentMode = .scaleAspectFill
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
            let matchOwnerDic = usersDic[self.currentUsernameString] as! [String:Any]
            // make a dictionary out of the pet
            let pets = matchOwnerDic["pets"] as! [String:Any]
            let dogDic = pets[pets.startIndex].value as! [String:Any]
            // extract dog data
            self.lb_dogName.text = dogDic["name"] as? String
            self.lb_dogBreed.text = "Breed: \(dogDic["breed"] as! String)"
            self.lb_dogAge.text = "Age: \(self.getYears(birthdate: dogDic["birthdate"] as? String)) years old"
            if dogDic["personality"] as! String == "true" {
                self.img_energetic.image = UIImage(named: "check-2")
            }else{
                self.img_energetic.image = UIImage(named: "close")
            }
            if dogDic["experience"] as! String == "true" {
                self.img_parental.image = UIImage(named: "check-2")
            }else{
                self.img_parental.image = UIImage(named: "close")
            }
            if dogDic["vaccinated"] as! String == "true" {
                self.img_vaccinated.image = UIImage(named: "check-2")
            }else{
                self.img_vaccinated.image = UIImage(named: "close")
            }
            let email = matchOwnerDic["email"] as! String
            self.storage.child("images/\(email)dog.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                    UserDefaults.standard.set("urlString", forKey: "urlDogImage")
                    return
                }
                let urlString = url.absoluteString
                // set it as user default so load image can use this value
                UserDefaults.standard.set(urlString, forKey: "urlDogImage")
                self.loadImage()
            })
            // extract owner data
            self.lb_ownerName.text = "Name: \(matchOwnerDic["name"]!) \(matchOwnerDic["lastName"]!)"
            self.lb_ownerAge.text = "Age: \(self.getYears(birthdate: matchOwnerDic["birthdate"] as? String)) years"
            self.lb_ownerOccupation.text = "Occupation: \(matchOwnerDic["occupation"]!)"
            self.lb_email.text = "Email: \(matchOwnerDic["email"]!)"
            
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
        guard let urlString = UserDefaults.standard.value(forKey: "urlDogImage") as? String,
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
