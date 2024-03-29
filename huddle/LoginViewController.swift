//
//  LoginViewController.swift
//  huddle
//
//  Created by Mateo Garcia on 3/23/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import Parse

class LoginViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var loadAnimationView: LoadAnimationView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    fileprivate var chooseMediaAC: UIAlertController!
    fileprivate var imagePickerVC: UIImagePickerController!
    
    /** NOTE: These variables must be updated if the layout of
              the login view changes in the storyboard. **/
    let kLoginViewSignupHeight: CGFloat = 185
    
    // Height of Name and Email textviews, plus the spacing below each.
    let kLoginViewExtraHeightOnSignup: CGFloat = 58
    var kLoginViewLoginHeight: CGFloat!
    var kLoginViewLoginWidth: CGFloat = 165
    
    var loginLabel: UILabel!
    var loginLabelOriginalOrigin: CGPoint!
    
    let kLoginString = "LOG IN"
    let kLoggingInString = "LOGGING IN..."
    
    var loginButtonOriginalColor: UIColor!
    var signupButtonOriginalColor: UIColor!
    
    var lastFirstResponder: UITextField?
    
    var inSignupMode = true
    var shouldContinueAnimating = false
    
    var profilePhotoImage: UIImage?
    
    
    let kWelcomeMessageKey = "LoginViewControllerWelcomeMessageDisplayed"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadAnimationView.isHidden = true
        
        self.kLoginViewLoginHeight = self.kLoginViewSignupHeight - self.kLoginViewExtraHeightOnSignup
        
        self.loginView.layer.cornerRadius = 4
        self.loginView.layer.masksToBounds = true
        
        // Initialize in login mode.
        self.loginViewHeightConstraint.constant = self.kLoginViewLoginHeight
        self.loginViewWidthConstraint.constant = self.kLoginViewLoginWidth
        self.nameTextField.isHidden = true
        self.nameTextField.alpha = 0
        self.emailTextField.isHidden = true
        self.emailTextField.alpha = 0
        self.inSignupMode = false
        
        // Name text field.
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName : UIColor.gray])
        self.nameTextField.keyboardAppearance = UIKeyboardAppearance.dark
        self.nameTextField.delegate = self
        self.nameTextField.returnKeyType = .next
        
        // Email text field.
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.gray])
        self.emailTextField.keyboardAppearance = UIKeyboardAppearance.dark
        self.emailTextField.delegate = self
        self.nameTextField.nextTextField = self.emailTextField
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.returnKeyType = .next
        
        // Username text field.
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.gray])
        self.usernameTextField.keyboardAppearance = UIKeyboardAppearance.dark
        usernameTextField.delegate = self
        self.emailTextField.nextTextField = self.usernameTextField
        self.usernameTextField.returnKeyType = .next
        
        // Password text field.
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.gray])
        self.passwordTextField.keyboardAppearance = UIKeyboardAppearance.dark
        passwordTextField.delegate = self
        self.usernameTextField.nextTextField = self.passwordTextField
        self.passwordTextField.returnKeyType = .go
        
        // Take or choose profile photo.
        self.chooseMediaAC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.chooseMediaAC.addAction(UIAlertAction(title: "CLICK", style: .default, handler: { _ in
            self.presentImagePicker(usingPhotoLibrary: false)
        }))
        self.chooseMediaAC.addAction(UIAlertAction(title: "CHOOSE", style: .default, handler: { _ in
            self.presentImagePicker(usingPhotoLibrary: true)
        }))
        self.chooseMediaAC.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { _ in
            self.chooseMediaAC.dismiss(animated: true, completion: nil)
        }))
        
        // Image picker.
        self.imagePickerVC = UIImagePickerController()
        self.imagePickerVC.delegate = self
        self.imagePickerVC.allowsEditing = true
        self.imagePickerVC.mediaTypes = [kUTTypeImage as String] /* , kUTTypeMovie as String] */
        
        self.addPhotoButton.isHidden = true
        self.addPhotoButton.alpha = 0
        
        self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.width / 2
        self.profilePhotoImageView.clipsToBounds = true
        self.profilePhotoImageView.isHidden = true
        self.profilePhotoImageView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.usernameTextField.becomeFirstResponder()
        
        if UserDefaults.standard.object(forKey: self.kWelcomeMessageKey) == nil {
            let ac = UIAlertController(title: "Welcome", message: "Human connection matters.\n\nStudies prove human connection is essential​ to happiness, mental health and thriving community.\n\nTechnology today.\n\nTech keeps us  highly \"connected\" yet has created a largely impersonal world that has eroded the fabric of real human relationships and community. In an era of polarizing politics, fear of other and fake news propagated through media, human connection matters now more than ever to overcome and dispell the severity of our purported differences.\n\nIt's time to forge real human connections and rebuild real-world community.\n\nMeet huddle.\n\nThe application that provides strangers  the opportunity to get together (huddle) in public spaces to engage in spontaneous communal activities.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: self.kWelcomeMessageKey)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let isAdmin = PFUser.current()?.object(forKey: "is_admin") as? Bool {
            AppDelegate.isAdmin = isAdmin
        } else {
            AppDelegate.isAdmin = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.addLoginLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Login and Signup Helpers

extension LoginViewController {
    fileprivate func logInUser(_ username: String, password: String) {
        let un = username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pw = password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // Local error checks.
        if un.characters.count == 0 {
            let ac = UIAlertController(title: "Invalid Username", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
            return
        } else if pw.characters.count == 0 {
            let ac = UIAlertController(title: "Invalid Password", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
            return
        }
        
        self.startLoginAnimation()
        PFUser.logInWithUsername(inBackground: un, password: pw) { (user: PFUser?, error: Error?) -> Void in
            if let error = error {
                
                print("LOGIN FAILED")
                
                self.endLoginAnmation()
                
                print("LOGIN ERROR:", error._code)
                
                switch error._code {
                case 101:
                    let ac = UIAlertController(title: "Invalid Username or Password", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                default:
                    let ac = UIAlertController(title: "Could not Connect", message: "Check your Internet connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
            } else if let user = user {
                
                print("LOGIN SUCCESSFUL")
                
                self.completeLogin()
            }
        }
    }
    
    fileprivate func signUpUser(_ name: String, email: String, username: String, password: String) {
        let nm = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let em = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let un = username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pw = password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // Local error checks.
        if nm.characters.count == 0 {
            let ac = UIAlertController(title: "Invalid Name", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
            return
        }
        if em.characters.count == 0 || !isValidEmail(em) {
            let ac = UIAlertController(title: "Invalid Email", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
            return
        }
        if un.characters.count == 0 {
            let ac = UIAlertController(title: "Invalid Username", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
            return
        } else if pw.characters.count == 0 {
            let ac = UIAlertController(title: "Invalid Password", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
            return
        }
        
        self.startLoginAnimation()
        
        let newUser = PFUser()
        newUser["name"] = nm
        newUser.email = em
        newUser.username = un
        newUser.password = pw
        if let image = self.profilePhotoImage {
            let imageData = UIImageJPEGRepresentation(image, 100)
            let imageFile = PFFile(name: "image.jpeg", data: imageData!)
            newUser["profilePhotoImageFile"] = imageFile
        }
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                
                print("LOGIN FAILED")
                
                self.endLoginAnmation()
                
                print("LOGIN ERROR:", error._code)
                
                switch error._code {
                case 101:
                    let ac = UIAlertController(title: "Invalid Username or Password", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                default:
                    let ac = UIAlertController(title: "Could not Connect", message: "Check your Internet connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
            } else {
                
                print("SIGNUP SUCCESSFUL")
                
                self.completeLogin()
            }
        }
    }
    
    /* Called after user has successfully logged in and PFUser.currentUser() is set. */
    fileprivate func completeLogin() {
        
        /** SAVE DEVICE INSTALLATION **/
        
        // Save username to NSUserDefaults in case PFUser.currentUser() fails in share extension.
        UserDefaults.standard.set(PFUser.current()!.username!, forKey: "Username")
        let installation = PFInstallation.current()!
        installation["user"] = PFUser.current()!
        installation["username"] = PFUser.current()!.username!
        installation.saveInBackground(block: { (completed: Bool, error: Error?) in
            print("USER SAVED WITH INSTALLATION")
        })
        
        self.endLoginAnmation()
        self.view.endEditing(true)
        self.transitionToApp()
    }
    
    fileprivate func isValidEmail(_ testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}


// MARK: - UI Helpers

extension LoginViewController {
    fileprivate func showSignupMode(_ show: Bool) {
        self.inSignupMode = show
        self.view.endEditing(true)
        
        let animationDuration: TimeInterval = 0.2
        
        if show {
            self.loginViewHeightConstraint.constant = self.kLoginViewSignupHeight
            self.loginViewWidthConstraint.constant = UIScreen.main.bounds.width - 80
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            self.nameTextField.isHidden = false
            self.emailTextField.isHidden = false
            self.addPhotoButton.isHidden = false
            self.profilePhotoImageView.isHidden = false
            UIView.animate(withDuration: animationDuration, delay: 0.1, options: .transitionCrossDissolve, animations: {
                self.nameTextField.alpha = 1
                self.emailTextField.alpha = 1
                if self.profilePhotoImageView.image == nil {
                    self.addPhotoButton.alpha = 1
                }
                self.profilePhotoImageView.alpha = 1
            }, completion: nil)
        } else {
            UIView.animate(withDuration: animationDuration, animations: { 
                self.nameTextField.alpha = 0
                self.emailTextField.alpha = 0
                self.addPhotoButton.alpha = 0
                self.profilePhotoImageView.alpha = 0
            }, completion: { _ in
                self.nameTextField.isHidden = true
                self.emailTextField.isHidden = true
                self.addPhotoButton.isHidden = true
                self.profilePhotoImageView.isHidden = true
            })
            
            self.loginViewHeightConstraint.constant = self.kLoginViewLoginHeight
            self.loginViewWidthConstraint.constant = self.kLoginViewLoginWidth
            UIView.animate(withDuration: animationDuration, delay: 0.1, options: .transitionCrossDissolve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    fileprivate func clearTextFields() {
        self.nameTextField.text = nil
        self.usernameTextField.text = nil
        self.emailTextField.text = nil
    }
}


// MARK: - Login Animation Helpers

extension LoginViewController {
    fileprivate func startLoginAnimation() {
        self.view.endEditing(true)
        
        let animationDuration = 0.5
        self.shouldContinueAnimating = true
        
        self.loginLabel.isHidden = false
        self.loginButton.isHidden = true
        UIView.animate(withDuration: animationDuration, animations: {
            self.loginLabel.text = self.kLoggingInString
            self.loginLabel.sizeToFit()
            self.loginLabel.center.x = self.loginView.center.x
        }, completion: { _ in
            self.pulseLoginLabel()
        })
        
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
        UIView.transition(with: self.backgroundImageView, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            self.backgroundImageView.alpha = 0
            // self.loginBackgroundImageIndex = (self.loginBackgroundImageIndex + 1) % self.loginBackgroundImageNames.count
        }, completion: { _ in
            // self.backgroundImageView.image = UIImage(named: self.loginBackgroundImageNames[self.loginBackgroundImageIndex])
        })
        
        var controlsToHide: [UIControl]!
        if self.inSignupMode {
            controlsToHide = [self.nameTextField, self.emailTextField, self.usernameTextField, self.passwordTextField, self.loginButton]
        } else {
            controlsToHide = [self.usernameTextField, self.passwordTextField, self.signupButton]
        }
        UIView.animate(withDuration: animationDuration, delay: 0.1, options: .transitionCrossDissolve, animations: {
            controlsToHide.forEach({ $0.alpha = 0 })
        }, completion: { _ in
            controlsToHide.forEach({ $0.isHidden = true })
        })
        
        UIView.transition(with: self.loadAnimationView, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            self.loadAnimationView.startAnimating()
            self.loadAnimationView.isHidden = false
        }, completion: nil)
    }
    
    fileprivate func endLoginAnmation() {
        let animationDuration = 0.5
        self.shouldContinueAnimating = false
        
        // Return duplicate login label to login button title label's position.
        UIView.animate(withDuration: animationDuration, animations: {
            self.loginLabel.text = self.kLoginString
            self.loginLabel.sizeToFit()
            self.loginLabel.frame.origin.x = self.loginLabelOriginalOrigin.x
        }, completion: { _ in
            self.loginButton.isHidden = false
            self.loginLabel.isHidden = true
        })
        
        var controlsToShow: [UIControl]!
        if self.inSignupMode {
            controlsToShow = [self.nameTextField, self.emailTextField, self.usernameTextField, self.passwordTextField, self.loginButton]
        } else {
            controlsToShow = [self.usernameTextField, self.passwordTextField, self.signupButton]
        }
        controlsToShow.forEach({ $0.isHidden = false })
        UIView.animate(withDuration: animationDuration, delay: 0.1, options: .transitionCrossDissolve, animations: {
            controlsToShow.forEach({ $0.alpha = 1 })
        }, completion: nil)
        
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        UIView.transition(with: self.backgroundImageView, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            self.backgroundImageView.alpha = 1
        }, completion: nil)
        UIView.transition(with: self.loadAnimationView, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            self.loadAnimationView.isHidden = true
            self.loadAnimationView.stopAnimating()
        }, completion: nil)
        
        self.lastFirstResponder?.becomeFirstResponder()
    }
    
    // Login label used as duplicate of login button title label for animations.
    fileprivate func addLoginLabel() {
        self.loginLabel = UILabel()
        self.loginLabel.text = self.loginButton.titleLabel!.text
        self.loginLabel.textColor = self.loginButton.titleLabel!.textColor
        self.loginLabel.font = self.loginButton.titleLabel!.font
        let loginButtonTitleLabelFrame = self.loginButton.convert(self.loginButton.titleLabel!.frame, to: self.view)
        self.loginLabel.frame = CGRect(x: loginButtonTitleLabelFrame.origin.x, y: loginButtonTitleLabelFrame.origin.y, width: loginButtonTitleLabelFrame.width, height: loginButtonTitleLabelFrame.height)
        self.loginLabelOriginalOrigin = self.loginLabel.frame.origin
        self.loginLabel.isHidden = true
        self.view.addSubview(self.loginLabel)
        
        self.exemptLoginLabelFrameFromDeltAnimation()
    }
    
    fileprivate func exemptLoginLabelFrameFromDeltAnimation() {
        self.loginLabel.text = self.kLoggingInString
        self.loginLabel.sizeToFit()
        self.loginLabel.center.x = self.loginView.center.x
        self.loadAnimationView.addExemptFrames(self.loginLabel.frame)
        self.loginLabel.text = self.kLoginString
        self.loginLabel.sizeToFit()
        self.loginLabel.frame.origin.x = self.loginLabelOriginalOrigin.x
    }
    
    // WARNING: Recursive loop could cause stack overflow.
    fileprivate func pulseLoginLabel() {
        UIView.animate(withDuration: 1, animations: {
            self.loginLabel.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 2, animations: {
                self.loginLabel.alpha = 1
            }, completion: { _ in
                if self.shouldContinueAnimating {
                    self.pulseLoginLabel()
                }
            })
        })
    }
    
    fileprivate func transitionToApp() {
        let animationDuration = 0.5
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        UIView.transition(with: self.view.window!, duration: animationDuration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
            self.view.window!.rootViewController = appDelegate.mapViewController
        }, completion: nil)
    }
}


// MARK: - Text Field Delegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .go:
            self.goKeyPressed()
        default:
            textField.nextTextField?.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lastFirstResponder = textField
    }
}


// MARK: - Image Picker Controller Delegate

extension LoginViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profilePhotoImage = image
            self.profilePhotoImageView.image = image
            print("BANANANA")
        }
        self.addPhotoButton.alpha = 0
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Image Picker Controller Helpers

extension LoginViewController {
    fileprivate func presentImagePicker(usingPhotoLibrary photoLibrary: Bool) {
        if photoLibrary {
            self.imagePickerVC.sourceType = .photoLibrary
            self.imagePickerVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: imagePickerVC, action: nil)
        } else {
            self.imagePickerVC.sourceType = .camera
        }
        self.present(self.imagePickerVC, animated: true, completion: nil)
    }
}


// MARK: - Actions

extension LoginViewController {
    @IBAction func onAddPhotoButtonTapped(_ sender: Any) {
        self.present(self.chooseMediaAC, animated: true, completion: nil)
    }
    
    func goKeyPressed() {
        if self.inSignupMode {
            self.signupButton.sendActions(for: .touchUpInside)
        } else {
            self.loginButton.sendActions(for: .touchUpInside)
        }
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        if self.inSignupMode {
            self.showSignupMode(false)
        } else {
            if let username = self.usernameTextField.text, let password = self.passwordTextField.text {
                self.logInUser(username, password: password)
            }
        }
    }
    
    @IBAction func signupPressed(_ sender: AnyObject) {
        self.view.endEditing(true)
        if self.inSignupMode {
            if let email = self.emailTextField.text,
                let name = self.nameTextField.text,
                let username = self.usernameTextField.text,
                let password = self.passwordTextField.text {
                
                self.signUpUser(name, email: email, username: username, password: password)
            }
        } else {
            self.showSignupMode(true)
        }
    }
    
    @IBAction func onBackgroundTapped(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.lastFirstResponder = nil
    }
}
