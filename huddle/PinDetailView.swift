//
//  PinDetailView.swift
//  huddle
//
//  Created by Mateo Garcia on 3/28/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol PinDetailViewDelegate {
    func pinDetailViewCloseButtonTapped()
    func pinDetailView(didTapJoin pin: PFObject)
    func pinDetailView(didFlag pin: PFObject)
    func pinDetailView(didRemoveFlag pin: PFObject)
}

class PinDetailView: UIView {

    @IBOutlet weak var creatorProfileImageView: UIImageView!
    @IBOutlet weak var pinTypeImageView: UIImageView!
    @IBOutlet weak var pinTypeLabel: UILabel!
    @IBOutlet weak var timeDistanceLabel: UILabel!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var creatorSocialMediaHandleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pinPhotoImageView: UIImageView!
    @IBOutlet weak var joinButton: UIButton!
    
    var pin: PFObject! {
        didSet {
            if let creator = pin["createdBy"] as? PFUser {
                self.creatorNameLabel.text = creator["name"] as? String
                // self.creatorSocialMediaHandleLabel.text = creator[
                if let imageFile = creator["profileImageFile"] as? PFFile {
                    let pfImageView = PFImageView()
                    pfImageView.file = imageFile
                    pfImageView.load(inBackground: { (image: UIImage?, error: Error?) in
                        if error != nil {
                            print("Error: \(error!.localizedDescription)")
                        } else {
                            self.creatorProfileImageView.image = image
                        }
                    })
                }
            }
            
            if let pinTypeString = pin["pinType"] as? String {
                if let pinType = PinType.PinType(rawValue: pinTypeString) {
                    self.pinTypeImageView.image = PinType.pinTypeImage[pinType]
                    self.pinTypeLabel.text = PinType.pinTypeName[pinType]
                }
            }
            
            // TODO: Calculate distance from current location.
            // self.timeDistanceLabel.text =
            
            if let description = self.pin["description"] as? String {
                self.descriptionLabel.text = "\"" + description + "\""
            } else {
                self.descriptionLabel.text = "[no description]"
            }
            
            if let imageFile = pin["imageFile"] as? PFFile {
                let pfImageView = PFImageView()
                pfImageView.file = imageFile
                pfImageView.load(inBackground: { (image: UIImage?, error: Error?) in
                    if error != nil {
                        print("Error: \(error!.localizedDescription)")
                    } else {
                        self.pinPhotoImageView.image = image
                    }
                })
            }
            
            print(PFUser.current()!)
            
            if let flaggedByMe = PFUser.current()?["flaggedByMe"] as? [String] {
                self.flagged =  flaggedByMe.contains(pin.objectId!)
            }
        }
    }
    
    var flagged = false {
        didSet {
            self.flagButton.isSelected = self.flagged
        }
    }
    
    var delegate: PinDetailViewDelegate?
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set(hide) {
            super.isHidden = hide
            
            if hide {
                self.creatorProfileImageView.image = nil
                self.pinTypeImageView.image = nil
                self.pinTypeLabel.text = nil
                self.timeDistanceLabel.text = nil
                self.creatorNameLabel.text = nil
                self.creatorSocialMediaHandleLabel.text = nil
                self.descriptionLabel.text = nil
                self.pinPhotoImageView.image = nil
                self.flagged = false
            }
        }
    }
}


// MARK: - Actions

extension PinDetailView {
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        self.delegate?.pinDetailViewCloseButtonTapped()
    }
    
    @IBAction func onFlagButtonTapped(_ sender: Any) {
        self.flagged = !self.flagged
        if self.flagged {
            self.delegate?.pinDetailView(didFlag: self.pin)
        } else {
            self.delegate?.pinDetailView(didRemoveFlag: self.pin)
        }
    }
    
    @IBAction func onJoinButtonTapped(_ sender: Any) {
        self.delegate?.pinDetailView(didTapJoin: self.pin)
    }
}
