//
//  ViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/3/21.
//

import UIKit
import Firebase
//import FirebaseCore
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//import FirebaseDatabase


// STEP #2: CREATE A CONSTANT FOR THE REFERENCE TO THE REALTIME DATABASE
//let db = Firestore.firestore()
//var data = [String:Any]()

class ViewController: UIViewController {
//    var db: Firestore! 
    
    @IBOutlet weak var vProfile1: UIView!
    @IBOutlet weak var vProfile2: UIView!
    @IBOutlet weak var vProfile3: UIView!
    @IBOutlet weak var vProfile4: UIView!
    
    @IBOutlet weak var vMatch1: UIView!
    @IBOutlet weak var vMatch2: UIView!
    @IBOutlet weak var vMatch3: UIView!
    @IBOutlet weak var vMatch4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vProfile1.layer.cornerRadius = 10.0
        vProfile2.layer.cornerRadius = 10.0
        vProfile3.layer.cornerRadius = 10.0
        vProfile4.layer.cornerRadius = 10.0
        
        vMatch1.layer.cornerRadius = 10.0
        vMatch2.layer.cornerRadius = 10.0
        vMatch3.layer.cornerRadius = 10.0
        vMatch4.layer.cornerRadius = 10.0
        
        // Do any additional setup after loading the view.
        // [START setup]
//               let settings = FirestoreSettings()

//               Firestore.firestore().settings = settings
               // [END setup]
//               db = Firestore.firestore()
        
        
    }

  
    
}

