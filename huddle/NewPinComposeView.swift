//
//  NewPinComposeView.swift
//  huddle
//
//  Created by Mateo Garcia on 3/27/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol NewPinComposeViewDelegate {
    func newPinComposeViewCancelButtonTapped()
    func newPinComposeView(didPostPin pinType: PinType.PinType, withDescription description: String)
}

class NewPinComposeView: UIView {
    
    @IBOutlet weak var pinTypeImageView: UIImageView!
    @IBOutlet weak var pinTypeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: CustomTextView!
    @IBOutlet weak var descriptionTextViewHeight: NSLayoutConstraint!
    var delegate: NewPinComposeViewDelegate?
    
    var currentHUD = MBProgressHUD()
    
    var pinType: PinType.PinType! {
        didSet {
            if pinType != nil {
                self.pinTypeImageView.image = PinType.pinTypeImage[self.pinType]
                self.pinTypeLabel.text = PinType.pinTypeName[self.pinType]
            }
        }
    }
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set(hide) {
            super.isHidden = hide
            
            if hide {
                self.pinType = nil
                self.pinTypeImageView?.image = nil
                self.descriptionTextView?.text = ""
                self.descriptionTextViewHeight?.constant = self.defaultDescriptionTextViewtHeight
                self.endEditing(true)
            }
        }
    }
    
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
        //
    }
    
    override func awakeFromNib() {
        self.descriptionTextViewHeight.constant = self.descriptionTextView.contentSize.height
        self.defaultDescriptionTextViewtHeight = self.descriptionTextViewHeight.constant
        self.descriptionTextView.delegate = self
        self.descriptionTextView.placeholder = "Comment:"
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


// MARK: - Actions

extension NewPinComposeView {
    @IBAction func onViewTapped(_ sender: Any) {
        self.endEditing(true)
    }
    
    @IBAction func onCancelButtonTapped(_ sender: Any) {
        self.delegate?.newPinComposeViewCancelButtonTapped()
    }
    
    @IBAction func onCreatePinTapped(_ sender: Any) {
        self.currentHUD = MBProgressHUD.showAdded(to: self, animated: true)
        self.currentHUD.label.text = "Posting..."
        
        self.delegate?.newPinComposeView(didPostPin: self.pinType, withDescription: self.descriptionTextView.text)
    }
}
