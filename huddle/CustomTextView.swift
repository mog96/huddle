//
//  CustomTextView.swift
//  XCHAT
//
//  Created by Mateo Garcia on 11/18/16.
//  Copyright © 2016 Mateo Garcia. All rights reserved.
//

import UIKit

/**
 Imitates behavior of UITextField, with same placeholder color and placeholder behavior.
 NOTE: If text is set programatically, placeholder WILL NOT disappear. (This would require
       overriding a didSet...)
 */
class CustomTextView: UITextView {
    
    var placeholderLabel: UILabel!
    var placeholder = "" {
        didSet {
            self.placeholderLabel.text = self.placeholder
            self.placeholderLabel.sizeToFit()
        }
    }
    var placeholderTextColor = UIColor(red: 199/256, green: 199/256, blue: 205/256, alpha: 1) /* Official Apple gray placeholder text color. */
    
    fileprivate var shouldRemovePlaceholderOnTextChange = false
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.placeholderLabel = UILabel()
        self.placeholderLabel.font = self.font
        self.placeholderLabel.textColor = self.placeholderTextColor
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.frame.origin = CGPoint(x: 5, y: self.font!.pointSize / 2 + 1)
        if self.font!.pointSize >= 20 {
            self.placeholderLabel.frame.origin = CGPoint(x: 5, y: self.font!.pointSize / 2 - 1.5)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didBeginEditing), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEndEditing), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
}


// MARK: - External helpers

extension CustomTextView {
    func clear() {
        self.text = ""
        self.placeholderLabel.isHidden = false
    }
}


// MARK: - Notification Listeners

extension CustomTextView {
    @objc fileprivate func didBeginEditing() {
        self.placeholderLabel.isHidden = self.text.characters.count != 0
    }
    
    @objc fileprivate func textDidChange() {
        self.placeholderLabel.isHidden = self.text.characters.count != 0
    }
    
    @objc fileprivate func didEndEditing() {
        self.placeholderLabel.isHidden = self.text.characters.count != 0
    }
}
