//
//  MatchesViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/24/21.
//

import UIKit
import Firebase

struct matchStruct {
    let name: String!
    let imageUrl: String!
    let owner: String!
}

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var currentUsernameString = UserDefaults.standard.value(forKeyPath: "currentUsername") as! String
    
    var matches = [matchStruct]()
    
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
        
        print("\(matches[indexPath.row].name!) + \(matches[indexPath.row].owner!) + \(matches.count)")
        return UITableViewCell()
    }
    
    func loadMatches(){
        
        
        // reference users
        let ref = Database.database().reference(withPath: "users")
        // observe the event with its value
        ref.observeSingleEvent(of: .value, with: { snapshot in
            // check to see if snapshot exists
            if !snapshot.exists() { return }
            
            print(snapshot)
            // all users' dictionary
            let usersDictionary = snapshot.value as! [String:Any]
            // current user's dictionary
            let currentUserDictionary = usersDictionary["\(self.currentUsernameString)"] as! [String:Any]
            // create dictionary from the likes
            let currentUserLikesDictionary = currentUserDictionary["likes"] as! [String:Any]

            for key in currentUserLikesDictionary.keys{
                print(key)
                // dictionary for the like's info
                let likeDictionary = usersDictionary["\(key)"] as! [String:Any]
                let likeLikesDictionary = likeDictionary["likes"] as! [String:Any]

                if likeLikesDictionary["\(self.currentUsernameString)"] != nil{
                    self.loadDogInfo(userDictionary: likeDictionary)
                }
                self.tableView.reloadData()

            }
        })
            
//            // loop through all the likes
//            for like in snapshot.children{
//                // create a snap from the child to get the username as the key
//                let snap = like as! DataSnapshot
//                // create a new reference to get the info for the like
//                let ref2 = Database.database().reference(withPath: "users/\(snap.key)")
//                // observe the event of the the like's info
//                ref2.observeSingleEvent(of: .value, with: { snapshot2 in
//                    // create a dictionary of the like
//                    let userDictionary = snapshot2.value as! [String:Any]
//                    // create a dictionary with the childs's likes
//                    let userLikes = userDictionary["likes"] as! [String:Any]
//                    // check to see if the current user's username is contained in the dictionary of the child's likes
//                    if userLikes["\(self.currentUsernameString)"] != nil{
//                        // this means its a match
//                        // load dog info
//                        self.loadDogInfo(userDictionary: userDictionary)
//                    }
//                    // reload tableView inside here because data is deleted once observeSingleEvent is over
//                    self.tableView.reloadData()
//                })
//            }
//        })
        
//        // reference the currentUsername likes
//        let ref = Database.database().reference(withPath: "users/\(currentUsernameString)/likes")
//        // observe the event with its value
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//            // check to see if snapshot exists
//            if !snapshot.exists() { return }
//            // loop through all the likes
//            for like in snapshot.children{
//                // create a snap from the child to get the username as the key
//                let snap = like as! DataSnapshot
//                // create a new reference to get the info for the like
//                let ref2 = Database.database().reference(withPath: "users/\(snap.key)")
//                // observe the event of the the like's info
//                ref2.observeSingleEvent(of: .value, with: { snapshot2 in
//                    // create a dictionary of the like
//                    let userDictionary = snapshot2.value as! [String:Any]
//                    // create a dictionary with the childs's likes
//                    let userLikes = userDictionary["likes"] as! [String:Any]
//                    // check to see if the current user's username is contained in the dictionary of the child's likes
//                    if userLikes["\(self.currentUsernameString)"] != nil{
//                        // this means its a match
//                        // load dog info
//                        self.loadDogInfo(userDictionary: userDictionary)
//                    }
//                    // reload tableView inside here because data is deleted once observeSingleEvent is over
//                    self.tableView.reloadData()
//                })
//            }
//        })
    }
    
    func loadDogInfo(userDictionary: [String:Any]!){
        
        let pets = userDictionary["pets"] as! [String:Any]
        let dogDictionary = pets[pets.startIndex].value as! [String:Any]
        
        let name = dogDictionary["name"] as! String
        let owner = (userDictionary["name"] as! String) + " " + (userDictionary["lastName"] as! String)
        self.matches.insert((matchStruct(name: name, imageUrl: "test", owner: owner)),at: 0)
            
    }
    

}
