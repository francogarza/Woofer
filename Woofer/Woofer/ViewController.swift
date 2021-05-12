//
//  ViewController.swift
//  Woofer
//
//  Created by Franco Garza on 5/3/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // [START setup]
               let settings = FirestoreSettings()

               Firestore.firestore().settings = settings
               // [END setup]
               db = Firestore.firestore()
    }

  
    
}

