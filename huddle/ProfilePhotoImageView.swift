//
//  ProfilePhotoImageView.swift
//  huddle
//
//  Created by Mateo Garcia on 4/30/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

class ProfilePhotoImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.commonInit()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.layer.borderColor = LayoutUtils.blueColor.cgColor
        self.layer.borderWidth = 2
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
