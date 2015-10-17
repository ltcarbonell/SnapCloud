//
//  UserTableViewCell.swift
//  SnapCloud
//
//  Created by LT Carbonell on 10/14/15.
//  Copyright © 2015 LT Carbonell. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet var fullname: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
