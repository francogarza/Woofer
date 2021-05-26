//
//  MatchesViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/24/21.
//

import UIKit
import Firebase
import FirebaseStorage

struct matchStruct {
    let name: String!
    let email: String!
    let imageUrl: String!
    let owner: String!
    let birthdate: String!
}

class MatchDogInfoCell: UITableViewCell{
    
    @IBOutlet weak var lb_dogName: UILabel!
    @IBOutlet weak var lb_dogAge: UILabel!
    @IBOutlet weak var lb_owner: UILabel!
    @IBOutlet weak var lb_email: UILabel!
    @IBOutlet weak var img_dogImage: UIImageView!
    
}

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var currentUsernameString = UserDefaults.standard.value(forKeyPath: "currentUsername") as! String
    
    var matches = [matchStruct]()
    
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        loadMatches()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchDogInfoCell") as! MatchDogInfoCell
        
        cell.lb_dogName.text = matches[indexPath.row].name!
        
        let birthdate = matches[indexPath.row].birthdate!
        
        let age = getYears(birthdate: birthdate)
        
        cell.lb_dogAge.text = "Age: \(age) years old"
        
        cell.lb_email.text = "Email: \(matches[indexPath.row].email!)"
        
        getImageUrl(email: matches[indexPath.row].email, cell: cell)
        cell.img_dogImage.contentMode = .scaleAspectFill
        
        cell.selectionStyle = .none
        
        cell.lb_owner.text = "Owner: \(matches[indexPath.row].owner!)"
        
        return cell
    }
    
    func loadMatches(){
        
        
        // reference users
        let ref = Database.database().reference(withPath: "users")
        // observe the event with its value
        ref.observeSingleEvent(of: .value, with: { snapshot in
            // check to see if snapshot exists
            if !snapshot.exists() { return }
            // all users' dictionary
            let usersDictionary = snapshot.value as! [String:Any]
            // current user's dictionary
            let currentUserDictionary = usersDictionary["\(self.currentUsernameString)"] as! [String:Any]
            // create dictionary from the likes
            let currentUserLikesDictionary = currentUserDictionary["likes"] as! [String:Any]

            for key in currentUserLikesDictionary.keys{
                // dictionary for the like's info
                if let likeDictionary = usersDictionary["\(key)"] as? [String:Any]{
                    
                    let likeLikesDictionary = likeDictionary["likes"] as! [String:Any]

                    if likeLikesDictionary["\(self.currentUsernameString)"] != nil{
                        self.loadDogInfo(userDictionary: likeDictionary)
                    }
                }
                
                self.tableView.reloadData()

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
    
    func getImageUrl(email: String!, cell: MatchDogInfoCell){
        self.storage.child("images/\(email!)dog.png").downloadURL(completion: {url, error in
            
            guard let url = url, error == nil else{
                UserDefaults.standard.set("urlString", forKey: "urlDogImage")
                return
            }
            
            let urlString = url.absoluteString
            
            // set it as user default so load image can use this value
            UserDefaults.standard.set(urlString, forKey: "urlDogImage")
            
            self.loadImage(cell: cell)
            
        })
        
        
    }
    
    func loadImage(cell: MatchDogInfoCell){
        
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
                cell.img_dogImage.image = image
            }
            
        })
        task.resume()
    }
    
    func loadDogInfo(userDictionary: [String:Any]!){
        
        let pets = userDictionary["pets"] as! [String:Any]
        let dogDictionary = pets[pets.startIndex].value as! [String:Any]
        
        let name = dogDictionary["name"] as! String
        let owner = (userDictionary["name"] as! String) + " " + (userDictionary["lastName"] as! String)
        let birthdate = dogDictionary["birthdate"] as! String
        let email = userDictionary["email"] as! String
        self.matches.insert((matchStruct(name: name, email: email, imageUrl: "test", owner: owner, birthdate: birthdate)),at: 0)
            
    }
    

}
