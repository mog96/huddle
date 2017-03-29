//
//  NewPinComposeView.swift
//  huddle
//
//  Created by Mateo Garcia on 3/27/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

protocol NewPinComposeViewDelegate {
    func newPinComposeViewCancelButtonTapped()
    func newPinComposeViewCameraButtonTapped()
    func newPinComposeView(didCreatePin pinWithoutLocation: PFObject)
}

class NewPinComposeView: UIView {
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var pinPhotoImageView: UIImageView!
    @IBOutlet weak var pinTypeImageView: UIImageView!
    @IBOutlet weak var pinTypeLabel: UILabel!
    @IBOutlet weak var coinButton: UIButton!
    @IBOutlet weak var coinCountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: CustomTextView!
    @IBOutlet weak var descriptionTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var coinCountPickerBackgroundView: UIVisualEffectView!
    @IBOutlet weak var coinCountPickerView: UIPickerView!
    
    var delegate: NewPinComposeViewDelegate?
    
    var currentHUD = MBProgressHUD()
    
    fileprivate var defaultDescriptionTextViewHeight: CGFloat!
    fileprivate let kMaxDescriptionTextViewHeight: CGFloat = 250
    fileprivate let coinCounts = [1, 2, 5, 10]
    
    var pinType: PinType.PinType! {
        didSet {
            if pinType != nil {
                self.pinTypeImageView.image = PinType.pinTypeImage[self.pinType]
                self.pinTypeLabel.text = PinType.pinTypeName[self.pinType]
                
                if pinType == .poiWiFi || pinType == .poiWC || pinType == .poiWater {
                    self.coinButton.isHidden = true
                    self.coinCountLabel.isHidden = true
                }
            }
        }
    }
    var coinCount: Int!
    var pinPhotoImage: UIImage?
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set(hide) {
            super.isHidden = hide
            
            if hide {
                self.pinType = nil
                self.pinTypeImageView?.image = nil
                self.coinButton.isHidden = false
                self.coinCountLabel.isHidden = false
                self.coinCount = self.coinCounts[0]
                self.coinCountLabel.text = String(self.coinCount)
                self.countPickerViewHidden = true
                self.pinPhotoImage = nil
                self.descriptionTextView?.clear()
                self.descriptionTextViewHeight?.constant = self.defaultDescriptionTextViewHeight
                self.endEditing(true)
            }
        }
    }
    
    var countPickerViewHidden = true {
        didSet {
            if self.coinCountPickerView.isHidden != self.countPickerViewHidden {
                UIView.transition(with: self.coinCountPickerBackgroundView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.coinCountPickerBackgroundView.isHidden = self.countPickerViewHidden
                }, completion: nil)
                UIView.transition(with: self.coinCountPickerView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.coinCountPickerView.isHidden = self.countPickerViewHidden
                }, completion: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        self.coinCount = self.coinCounts[0]
        self.coinCountLabel.text = String(self.coinCount)
        
        self.descriptionTextViewHeight.constant = self.descriptionTextView.contentSize.height
        self.defaultDescriptionTextViewHeight = self.descriptionTextViewHeight.constant
        self.descriptionTextView.delegate = self
        self.descriptionTextView.placeholder = "Comment:"
        
        self.pinPhotoImageView.layer.cornerRadius = self.pinPhotoImageView.frame.width / 2
        self.pinPhotoImageView.clipsToBounds = true
        self.pinPhotoImageView.isHidden = true
        
        self.coinCountPickerView.delegate = self
        self.coinCountPickerView.dataSource = self
        self.countPickerViewHidden = true
    }
}


// MARK: - Text View Delegate

extension NewPinComposeView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.countPickerViewHidden = true
    }
    
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


// MARK: - Picker View Delegate

extension NewPinComposeView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.coinCounts[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.coinCount = self.coinCounts[row]
        self.coinCountLabel.text = String(self.coinCount)
    }
}


// MARK: - Actions

extension NewPinComposeView {
    @IBAction func onViewTapped(_ sender: Any) {
        self.endEditing(true)
        self.countPickerViewHidden = true
    }
    
    @IBAction func onCancelButtonTapped(_ sender: Any) {
        self.delegate?.newPinComposeViewCancelButtonTapped()
    }
    
    @IBAction func onCameraButtonTapped(_ sender: Any) {
        self.delegate?.newPinComposeViewCameraButtonTapped()
        // TODO: Present image picker
        //  - On return, make add photo button alpha zero.
    }
    
    @IBAction func onCoinButtonTapped(_ sender: Any) {
        self.endEditing(true)
        self.countPickerViewHidden = false
    }
    
    @IBAction func onCreatePinTapped(_ sender: Any) {
        self.currentHUD = MBProgressHUD.showAdded(to: self, animated: true)
        self.currentHUD.label.text = "Posting..."
        
        let pin = PFObject(className: "Pin")
        pin["pinType"] = self.pinType.rawValue
        pin["description"] = self.descriptionTextView.text
        pin["coins"] = self.coinCount
        if let image = self.pinPhotoImage {
            let imageData = UIImageJPEGRepresentation(image, 100)
            let imageFile = PFFile(name: "image.jpeg", data: imageData!)
            pin["imageFile"] = imageFile
        }
        pin["createdBy"] = PFUser.current()
        
        self.delegate?.newPinComposeView(didCreatePin: pin)
    }
}
