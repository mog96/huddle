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
    
    @IBOutlet weak var pinTypeButton: UIButton!
    
    var delegate: NewPinTypeCollectionViewCellDelegate?
    
    var pinType: PinType.PinType! {
        didSet {
            self.pinTypeButton.setImage(PinType.pinTypeImage[self.pinType], for: .normal)
        }
    }
    
    @IBAction func onPinTypeButtonTapped(_ sender: Any) {
        self.delegate?.newPinTypeCollectionViewCell(tappedWithPinType: self.pinType)
    }
}
