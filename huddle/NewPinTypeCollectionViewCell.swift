//
//  NewPinTypeCollectionViewCell.swift
//  huddle
//
//  Created by Mateo Garcia on 3/26/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

protocol NewPinTypeCollectionViewCellDelegate {
    func newPinTypeCollectionViewCellButtonTapped()
}

class NewPinTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pinTypeButton: UIButton!
    
    var delegate: NewPinTypeCollectionViewCellDelegate?
    
    @IBAction func onPinTypeButtonTapped(_ sender: Any) {
        self.delegate?.newPinTypeCollectionViewCellButtonTapped()
    }
}
