//
//  CustomCell.swift
//  Woofer
//
//  Created by Diego Villarreal on 19/05/21.
//

import Foundation
import UIKit


class CustomCell: UITableViewCell{
    var image : UIImage!
    var name : String!
    var age : Int!
    var owner : String!
    
//    var messageView : UITextView = { () -> <#Result#> in
//        var textView = UITextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
