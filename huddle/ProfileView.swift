//
//  ProfileView.swift
//  huddle
//
//  Created by Mateo Garcia on 4/30/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate {
    func profileViewCloseButtonTapped()
}

class ProfileView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addProfilePhotoButton: UIButton!
    @IBOutlet weak var profilePhotoImageView: ProfilePhotoImageView!
    @IBOutlet weak var coinButton: UIButton!
    @IBOutlet weak var coinCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var showAccountVerification = false
    
    var delegate: ProfileViewDelegate?
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set(hide) {
            super.isHidden = hide
            
            if hide {
                self.profilePhotoImageView.image = nil
                self.coinCountLabel.text = nil
                self.showAccountVerification = false
            }
        }
    }
    
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
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "ProfileFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "FieldCell")
        self.tableView.register(UINib(nibName: "ProfileSocialMediaHandleTableViewCell", bundle: nil), forCellReuseIdentifier: "SocialMediaHandleCell")
        self.tableView.register(UINib(nibName: "ProfileBioTableViewCell", bundle: nil), forCellReuseIdentifier: "BioCell")
        self.tableView.register(UINib(nibName: "ProfileVerifyAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "VerifyAccountCell")
    }
}


// MARK: - Table View

extension ProfileView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell =  self.tableView.dequeueReusableCell(withIdentifier: "FieldCell") as! ProfileFieldTableViewCell
            cell.fieldNameLabel.text = "name:"
            return cell
        case 1:
            let cell =  self.tableView.dequeueReusableCell(withIdentifier: "FieldCell") as! ProfileFieldTableViewCell
            cell.fieldNameLabel.text = "username:"
            return cell
        case 2:
            let cell =  self.tableView.dequeueReusableCell(withIdentifier: "SocialMediaHandleCell") as! ProfileSocialMediaHandleTableViewCell
            if indexPath.row > 0 {
                cell.fieldNameLabel.isHidden = true
            }
            return cell
        case 3:
            let cell =  self.tableView.dequeueReusableCell(withIdentifier: "BioCell") as! ProfileBioTableViewCell
            return cell
        default: // case 5
            let cell =  self.tableView.dequeueReusableCell(withIdentifier: "VerifyAccountCell") as! ProfileVerifyAccountTableViewCell
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Name
        // Username
        // Social media handles
        // About
        // Verify tel.
        return self.showAccountVerification ? 5 : 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            // Return one cell per social media handle.
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == self.tableView.numberOfSections {
            return nil
        }
        
        let inset: CGFloat = 16
        let separatorView = UIView(frame: CGRect(x: inset, y: 0, width: self.tableView.frame.width - inset, height: 1))
        separatorView.backgroundColor = UIColor(colorLiteralRed: 244/255, green: 244/255, blue: 244/255, alpha: 244/255)
        let separatorContainerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width - inset, height: 1))
        separatorContainerView.addSubview(separatorView)
        return separatorContainerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
}


// MARK: - Actions

extension ProfileView {
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        self.delegate?.profileViewCloseButtonTapped()
    }
    
    @IBAction func onAddProfilePhotoButtonTapped(_ sender: Any) {
        //
    }
    
    @IBAction func onScreenTapped(_ sender: Any) {
        self.endEditing(true)
        
        print("BANANA")
    }
}
