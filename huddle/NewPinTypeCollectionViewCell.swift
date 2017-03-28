//
//  NewPinTypeCollectionViewCell.swift
//  huddle
//
//  Created by Mateo Garcia on 3/26/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

protocol NewPinTypeCollectionViewCellDelegate {
    func newPinTypeCollectionViewCell(tappedWithPinType pinType: PinType.PinType)
}

class NewPinTypeCollectionViewCell: UICollectionViewCell {
    
    // @IBOutlet weak var pinTypeButton: UIButton!
    @IBOutlet weak var pinTypeImageView: UIImageView!
    @IBOutlet weak var pinTypeLabel: UILabel!
    
    var delegate: NewPinTypeCollectionViewCellDelegate?
    
    var pinType: PinType.PinType! {
        didSet {
            // self.pinTypeButton.setImage(PinType.pinTypeImage[self.pinType], for: .normal)
            if pinType != nil {
                self.pinTypeImageView.image = PinType.pinTypeImage[self.pinType]
                self.pinTypeLabel.text = PinType.pinTypeString[self.pinType]
            }
        }
    }
    
    override func prepareForReuse() {
        self.pinType = nil
        self.pinTypeImageView.image = nil
        self.pinTypeLabel.text = nil
    }
}


// MARK: - Actions

extension NewPinTypeCollectionViewCell {
    /*
    @IBAction func onPinTypeButtonTapped(_ sender: Any) {
        self.delegate?.newPinTypeCollectionViewCell(tappedWithPinType: self.pinType)
    }
    */
}
