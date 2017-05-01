//
//  MenuView.swift
//  huddle
//
//  Created by Mateo Garcia on 3/26/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func menuViewCloseButtonTapped()
    func menuViewProfileButtonTapped()
}

class MenuView: UIView {
    
    var delegate: MenuViewDelegate?
    
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
}

// MARK: - Actions

extension MenuView {
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        self.delegate?.menuViewCloseButtonTapped()
    }
    
    // Profile button.
    @IBAction func on00Tapped(_ sender: Any) {
        self.delegate?.menuViewProfileButtonTapped()
    }
    
    // Filter button.
    @IBAction func on01Tapped(_ sender: Any) {
    }
    
    // Wallet button.
    @IBAction func on10Tapped(_ sender: Any) {
    }
    
    // History button.
    @IBAction func on11Tapped(_ sender: Any) {
    }
    
    // About button.
    @IBAction func on20Tapped(_ sender: Any) {
    }
    
    // Help button.
    @IBAction func on21Tapped(_ sender: Any) {
    }
    
    // Share button.
    @IBAction func on30Tapped(_ sender: Any) {
    }
    
    // Feedback button.
    @IBAction func on31Tapped(_ sender: Any) {
    }
}
