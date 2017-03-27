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
    
    @IBOutlet weak var descriptionTextView: CustomTextView!
    @IBOutlet weak var descriptionTextViewHeight: NSLayoutConstraint!
    
    var delegate: NewPinTypeSelectionViewDelegate?
    
    var defaultDescriptionTextViewtHeight: CGFloat!
    let kMaxDescriptionTextViewHeight: CGFloat = 300
    
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
        self.descriptionTextView.delegate = self
    }
    
    override func awakeFromNib() {
        self.descriptionTextViewHeight.constant = self.descriptionTextView.contentSize.height
        self.defaultDescriptionTextViewtHeight = self.descriptionTextViewHeight.constant
    }
}

extension NewPinComposeView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Manually resize when newline entered.
        if text == "\n" {
            self.descriptionTextViewHeight.constant = min(self.kMaxDescriptionTextViewHeight,  self.descriptionTextViewHeight.constant + textView.font!.lineHeight)
        
        // Otherwise just resize height to content size height.
        } else {
            self.descriptionTextViewHeight.constant = min(self.kMaxDescriptionTextViewHeight, self.descriptionTextView.contentSize.height)
        }
        return true
    }
}
