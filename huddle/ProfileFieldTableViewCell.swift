//
//  ProfileFieldTableViewCell.swift
//  huddle
//
//  Created by Mateo Garcia on 4/30/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

class ProfileFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var fieldValueLabel: UILabel!
    @IBOutlet weak var fieldValueTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    var isEditingFieldValue: Bool = false
    
    let kEditButtonTitleEdit = "EDIT"
    let kEditButtonTitleDone = "DONE"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.fieldValueTextField.isHidden = !self.isEditingFieldValue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


// MARK: - Actions

extension ProfileFieldTableViewCell {
    @IBAction func onEditButtonTapped(_ sender: Any) {
        self.isEditingFieldValue = !self.isEditingFieldValue
        
        self.fieldValueTextField.isHidden = !self.isEditingFieldValue
        
        if self.isEditingFieldValue {
            UIView.transition(with: self.editButton, duration: 0.2, options: .transitionCrossDissolve, animations: { 
                self.editButton.setTitle(self.kEditButtonTitleDone, for: .normal)
            }, completion: nil)
            self.fieldValueTextField.becomeFirstResponder()
        } else {
            UIView.transition(with: self.editButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.editButton.setTitle(self.kEditButtonTitleEdit, for: .normal)
            }, completion: nil)
            self.fieldValueLabel.text = self.fieldValueTextField.text
            self.endEditing(true)
        }
        
        self.fieldValueLabel.isHidden = self.isEditingFieldValue
    }
}
