//
//  WiFiPinDetailView.swift
//  huddle
//
//  Created by Mateo Garcia on 3/28/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol WiFiPinDetailViewDelegate: PinDetailViewDelegate {
    func wiFiPinDetailViewCloseButtonTapped()
    func wiFiPinDetailView(plusButtonTappedFor wiFiPin: PFObject)
    func wiFiPinDetailView(minusButtonTappedFor wiFiPin: PFObject)
}

class WiFiPinDetailView: PinDetailView {
    
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    override var pin: PFObject! {
        didSet {
            super.pin = pin
            
            if let wiFiUpVotedByMe = PFUser.current()?["wiFiUpVotedByMe"] as? [String] {
                self.plusButton.isEnabled = wiFiUpVotedByMe.contains(self.pin.objectId!)
            } else if let wiFiDownVotedByMe = PFUser.current()?["wiFiUpVotedByMe"] as? [String] {
                self.minusButton.isEnabled = wiFiDownVotedByMe.contains(self.pin.objectId!)
            }
        }
    }
    
    var wiFiPinDetailViewDelegate: WiFiPinDetailViewDelegate?
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set(hide) {
            super.isHidden = hide
            
            if self.descriptionLabel != nil {
                print("DESCRIPTION:", self.descriptionLabel.text)
            }
            
            if hide {
                self.minusButton.isEnabled = true
                self.plusButton.isEnabled = true
            }
        }
    }
}


// MARK: - Actions

extension WiFiPinDetailView {
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        self.wiFiPinDetailViewDelegate?.wiFiPinDetailViewCloseButtonTapped()
    }
    
    @IBAction func onMinusButtonTapped(_ sender: Any) {
        self.wiFiPinDetailViewDelegate?.wiFiPinDetailView(minusButtonTappedFor: self.pin)
        self.minusButton.isEnabled = false
    }
    
    @IBAction func onPlusButtonTapped(_ sender: Any) {
        self.wiFiPinDetailViewDelegate?.wiFiPinDetailView(plusButtonTappedFor: self.pin)
        self.plusButton.isEnabled = false
    }
}
