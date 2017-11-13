//
//  UsersTableViewCell.swift
//  Find Me
//
//  Created by Aashana on 11/4/17.
//  Copyright © 2017 Aashana. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    @IBOutlet var name : UILabel!
    @IBOutlet var city : UILabel!
    @IBOutlet var state : UILabel!
    @IBOutlet var country : UILabel!
    @IBOutlet var year : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
