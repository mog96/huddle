//
//  ProfileSocialMediaHandleTableViewCell.swift
//  huddle
//
//  Created by Mateo Garcia on 4/30/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

class ProfileSocialMediaHandleTableViewCell: UITableViewCell {

    @IBOutlet weak var socialNetworkIcon: UIImageView!
    @IBOutlet weak var socialHandleLabel: UILabel!
    @IBOutlet weak var socialHandleTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


// MARK: - Actions

extension ProfileSocialMediaHandleTableViewCell {
    @IBAction func onEditButtonTapped(_ sender: Any) {
        
    }
}
