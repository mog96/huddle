//
//  ProfileBioTableViewCell.swift
//  huddle
//
//  Created by Mateo Garcia on 4/30/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

class ProfileBioTableViewCell: UITableViewCell {

    @IBOutlet weak var bioTextView: UITextView!
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

extension ProfileBioTableViewCell {
    @IBAction func onEditButtonTapped(_ sender: Any) {
        //
    }
}
