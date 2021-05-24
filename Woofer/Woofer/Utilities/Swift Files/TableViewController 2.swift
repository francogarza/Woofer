//
//  TableViewController.swift
//  Woofer
//
//  Created by Diego Villarreal on 19/05/21.
//

import Foundation
import UIKit


struct CellData{
    let image: UIImage!
    let name: String!
    let age: Int!
    let owner: String!
}

class TableViewController: UITableViewController{
    
    var data = [CellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}
