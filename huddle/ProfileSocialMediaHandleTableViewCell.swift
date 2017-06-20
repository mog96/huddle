//
//  ProfileSocialMediaHandleTableViewCell.swift
//  huddle
//
//  Created by Mateo Garcia on 4/30/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

class ProfileSocialMediaHandleTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var socialNetworkIcon: UIImageView!
    @IBOutlet weak var socialHandleLabel: UILabel!
    @IBOutlet weak var socialHandleTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    var isEditingSocialHandle: Bool = false
    
    let kEditButtonTitleEdit = "EDIT"
    let kEditButtonTitleDone = "DONE"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.socialHandleTextField.isHidden = !self.isEditingSocialHandle
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


// MARK: - Actions

extension ProfileSocialMediaHandleTableViewCell {
    @IBAction func onEditButtonTapped(_ sender: Any) {
        self.isEditingSocialHandle = !self.isEditingSocialHandle
        
        self.socialHandleTextField.isHidden = !self.isEditingSocialHandle
        
        if self.isEditingSocialHandle {
            UIView.transition(with: self.editButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.editButton.setTitle(self.kEditButtonTitleDone, for: .normal)
            }, completion: nil)
            self.socialHandleTextField.becomeFirstResponder()
        } else {
            UIView.transition(with: self.editButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.editButton.setTitle(self.kEditButtonTitleEdit, for: .normal)
            }, completion: nil)
            self.socialHandleLabel.text = self.socialHandleTextField.text
            self.endEditing(true)
        }
        
        self.socialHandleLabel.isHidden = self.isEditingSocialHandle
    }
}
