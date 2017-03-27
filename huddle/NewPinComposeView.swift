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
    
    @IBOutlet weak var pinTypeImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: CustomTextView!
    @IBOutlet weak var descriptionTextViewHeight: NSLayoutConstraint!
    
    var delegate: NewPinTypeSelectionViewDelegate?
    
    var pinType: PinType.PinType?
    
    fileprivate var defaultDescriptionTextViewtHeight: CGFloat!
    fileprivate let kMaxDescriptionTextViewHeight: CGFloat = 250
    
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
        self.pinTypeImageView.image = PinType.pinTypeImage[self.pinType!]
        
        self.descriptionTextViewHeight.constant = self.descriptionTextView.contentSize.height
        self.defaultDescriptionTextViewtHeight = self.descriptionTextViewHeight.constant
    }
    
    @IBAction func onCreateFreedomBubbleTapped(_ sender: Any) {
        //
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
