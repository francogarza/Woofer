//
//  MyProfileViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/25/21.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {

    @IBOutlet weak var img_dogImage: UIImageView!
    @IBOutlet weak var lb_dogName: UILabel!
    @IBOutlet weak var lb_dogBreed: UILabel!
    @IBOutlet weak var lb_dogAge: UILabel!
    
    @IBOutlet weak var lb_ownerName: UILabel!
    @IBOutlet weak var lb_ownerAge: UILabel!
    @IBOutlet weak var lb_ownerOccupation: UILabel!
    @IBOutlet weak var lb_email: UILabel!
    
    let matchUsernameString = UserDefaults.standard.value(forKey: "browseUsername") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.lb_dogName.text = dogDic["name"] as? String
            self.lb_dogBreed.text = "Breed: \(dogDic["breed"] as! String)"
            self.lb_dogAge.text = "Age: \(self.getYears(birthdate: dogDic["birthdate"] as? String)) years old"
            self.loadImage()
            // extract owner data
            self.lb_ownerName.text = "Name: \(matchOwnerDic["name"]!) \(matchOwnerDic["lastName"]!)"
            self.lb_ownerAge.text = "Age: \(self.getYears(birthdate: matchOwnerDic["birthdate"] as? String)) years old"
            self.lb_ownerOccupation.text = "Occupation: \(matchOwnerDic["occupation"]!)"
            
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
