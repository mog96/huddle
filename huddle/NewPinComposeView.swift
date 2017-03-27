//
//  NewPinComposeView.swift
//  huddle
//
//  Created by Mateo Garcia on 3/27/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

protocol NewPinComposeViewDelegate {
    func newPinComposeViewCancelButtonTapped()
}

class NewPinComposeView: UIView {

    var delegate: NewPinTypeSelectionViewDelegate?
    
    @IBOutlet weak var descriptionTextView: CustomTextView!
    
    init(frame: CGRect, exemptFrames: CGRect...) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.descriptionTextView.placeholder = "Comment:"
    }
}
