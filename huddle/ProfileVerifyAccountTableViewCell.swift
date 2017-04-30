//
//  ProfileVerifyAccountTableViewCell.swift
//  huddle
//
//  Created by Mateo Garcia on 4/30/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

class ProfileVerifyAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var verifyAccountButton: UIButton!
    
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

extension ProfileVerifyAccountTableViewCell {
    @IBAction func onVerifyAccountButtonTapped(_ sender: Any) {
        //
    }
}
