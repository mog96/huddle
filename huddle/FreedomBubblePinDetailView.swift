//
//  FreedomBubblePinDetailView.swift
//  huddle
//
//  Created by Mateo Garcia on 3/29/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

protocol FreedomBubblePinDetailViewDelegate: PinDetailViewDelegate {
    func freedomBubblePinDetailViewCloseButtonTapped()
    func freedomBubblePinDetailView(didTapJoin pin: PFObject)
}

class FreedomBubblePinDetailView: PinDetailView {
    
    @IBOutlet weak var attendingCount: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    
    override var pin: PFObject! {
        didSet {
            super.pin = pin
            
            if let joinedByMe = PFUser.current()?["joinedByMe"] as? [String] {
                self.joinButton.isEnabled = !joinedByMe.contains(self.pin.objectId!)
            }
        }
    }
    
    var freedomBubblePinDetailViewDelegate: FreedomBubblePinDetailViewDelegate?
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set(hide) {
            super.isHidden = hide
            
            if hide {
                self.pinTypeImageView.image = nil
                self.pinTypeLabel.text = nil
                self.joinButton.isEnabled = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TODO: Detect whether this user joined.
    }
}


// MARK: - Actions

extension FreedomBubblePinDetailView {
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        self.freedomBubblePinDetailViewDelegate?.freedomBubblePinDetailViewCloseButtonTapped()
    }
    
    @IBAction func onJoinButtonTapped(_ sender: Any) {
        self.currentHUD = MBProgressHUD.showAdded(to: self, animated: true)
        self.currentHUD.label.text = "Joining..."
        
        self.freedomBubblePinDetailViewDelegate?.freedomBubblePinDetailView(didTapJoin: self.pin)
    }
}
