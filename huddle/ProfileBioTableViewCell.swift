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
    
    var isEditingBio: Bool = false
    
    let kEditButtonTitleEdit = "EDIT"
    let kEditButtonTitleDone = "DONE"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bioTextView.isEditable = self.isEditingBio
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


// MARK: - Actions

extension ProfileBioTableViewCell {
    @IBAction func onEditButtonTapped(_ sender: Any) {
        self.isEditingBio = !self.isEditingBio
        
        self.bioTextView.isEditable = self.isEditingBio
        
        if self.isEditingBio {
            UIView.transition(with: self.editButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.editButton.setTitle(self.kEditButtonTitleDone, for: .normal)
            }, completion: nil)
            self.bioTextView.becomeFirstResponder()
        } else {
            UIView.transition(with: self.editButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.editButton.setTitle(self.kEditButtonTitleEdit, for: .normal)
            }, completion: nil)
            self.endEditing(true)
        }
    }
}
