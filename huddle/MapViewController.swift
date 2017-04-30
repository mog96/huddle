//
//  MapViewController.swift
//  huddle
//
//  Created by Mateo Garcia on 3/19/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
import MediaPlayer
import MobileCoreServices
import Parse
import PureLayout

class MapViewController: UIViewController, UINavigationControllerDelegate {
    
    let METERS_PER_MILE = 1609.344

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    fileprivate var menuView: MenuView!
    fileprivate var newPinTypeSelectionView: NewPinTypeSelectionView!
    fileprivate var newPinComposeView: NewPinComposeView!
    fileprivate var freedomBubblePinDetailView: FreedomBubblePinDetailView!
    fileprivate var wiFiPinDetailView: WiFiPinDetailView!
    
    fileprivate var chooseMediaAC: UIAlertController!
    fileprivate var imagePickerVC: UIImagePickerController!
    
    fileprivate var statusBarHidden = false
    
    fileprivate var regionRadius: CLLocationDistance = 500     // meters
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var currentLocation: CLLocation?
    
    fileprivate var locationRequestedForNewPin = false
    fileprivate var newPin: PFObject!
    
    fileprivate var currentHUD = MBProgressHUD()
    
    fileprivate var pins = [PFObject]()
    
    fileprivate var firstLoad = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.menuView = Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)![0] as! MenuView
        self.view.addSubview(self.menuView)
        self.menuView.autoPinEdgesToSuperviewEdges()
        self.menuView.delegate = self
        self.menuView.alpha = 0
        self.menuView.isHidden = true
        
        self.newPinTypeSelectionView = Bundle.main.loadNibNamed("NewPinTypeSelectionView", owner: self, options: nil)![0] as! NewPinTypeSelectionView
        self.view.addSubview(self.newPinTypeSelectionView)
        self.newPinTypeSelectionView.autoPinEdgesToSuperviewEdges()
        self.newPinTypeSelectionView.delegate = self
        self.newPinTypeSelectionView.alpha = 0
        self.newPinTypeSelectionView.isHidden = true
        
        self.newPinComposeView = Bundle.main.loadNibNamed("NewPinComposeView", owner: self, options: nil)![0] as! NewPinComposeView
        self.view.addSubview(self.newPinComposeView)
        self.newPinComposeView.autoPinEdgesToSuperviewEdges()
        self.newPinComposeView.delegate = self
        self.newPinComposeView.alpha = 0
        self.newPinComposeView.isHidden = true
        
        self.freedomBubblePinDetailView = Bundle.main.loadNibNamed("FreedomBubblePinDetailView", owner: self, options: nil)![0] as! FreedomBubblePinDetailView
        self.view.addSubview(self.freedomBubblePinDetailView)
        self.freedomBubblePinDetailView.autoPinEdgesToSuperviewEdges()
        self.freedomBubblePinDetailView.pinDetailViewDelegate = self
        self.freedomBubblePinDetailView.freedomBubblePinDetailViewDelegate = self
        self.freedomBubblePinDetailView.alpha = 0
        self.freedomBubblePinDetailView.isHidden = true
        
        self.wiFiPinDetailView = Bundle.main.loadNibNamed("WiFiPinDetailView", owner: self, options: nil)![0] as! WiFiPinDetailView
        self.view.addSubview(self.wiFiPinDetailView)
        self.wiFiPinDetailView.autoPinEdgesToSuperviewEdges()
        self.wiFiPinDetailView.pinDetailViewDelegate = self
        self.wiFiPinDetailView.wiFiPinDetailViewDelegate = self
        self.wiFiPinDetailView.alpha = 0
        self.wiFiPinDetailView.isHidden = true
        
        self.searchButton.isHidden = true
        
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
        
        self.imagePickerVC = UIImagePickerController()
        self.imagePickerVC.delegate = self
        self.imagePickerVC.allowsEditing = true
        self.imagePickerVC.mediaTypes = [kUTTypeImage as String] /* , kUTTypeMovie as String] */
        
        /* INITIALIZE MAP */
        
        self.currentHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.currentHUD.label.text = "Orienting..."
        
        self.mapView.delegate = self
        self.mapView.showsPointsOfInterest = false
        
        // Default initial location to Golden Gate Park.
        var initialLocation = CLLocation(latitude: 37.769319, longitude: -122.487104)
        
        // Initialize map to old user location.
        if let location = UserDefaults.standard.object(forKey: "LastUserLocation") as? CLLocation {
            initialLocation = location
        }
        self.centerMapOnLocation(initialLocation)
        
        // With firstLoad set to true, location status check will trigger pin refresh when current user location found.
        self.firstLoad = true
        self.checkLocationAuthorizationStatus()
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.saveCurrentLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - Fetch Helpers

extension MapViewController {
    
    /* Refresh data at current location. */
    func refreshData() {
        self.currentHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.currentHUD.label.text = "Fetching Pins..."
        self.refreshData {
            self.currentHUD.hide(animated: true)
        }
    }
    
    func refreshData(completion: (() -> ())?) {
        let query = PFQuery(className: "Pin")
        query.includeKey("createdBy")
        
        if self.firstLoad {
            self.firstLoad = false
            query.whereKey("location", nearGeoPoint: PFGeoPoint(location: self.currentLocation), withinKilometers: Double(self.regionRadius))
        } else {
            let southwestCorner = self.mapView.convert(CGPoint(x: self.mapView.bounds.origin.x, y: self.mapView.bounds.origin.y + self.mapView.bounds.size.height), toCoordinateFrom: self.mapView)
            let northeastCorner = self.mapView.convert(CGPoint(x: self.mapView.bounds.origin.x + self.mapView.bounds.size.width, y: self.mapView.bounds.origin.y), toCoordinateFrom: self.mapView)
            let southwestPoint = PFGeoPoint(latitude: southwestCorner.latitude, longitude: southwestCorner.longitude)
            let northeastPoint = PFGeoPoint(latitude: northeastCorner.latitude, longitude: northeastCorner.longitude)
            
            print("QUERY FROM SW TO NE:", southwestPoint, northeastPoint)
            
            query.whereKey("location", withinGeoBoxFromSouthwest: southwestPoint, toNortheast: northeastPoint)
        }
        
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                self.pins = results!
                
                print("PINS:", self.pins)
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(self.pins.map({ Pin(object: $0) }))
            }
            completion?()
        }
    }
}


// MARK: - Location Helpers

extension MapViewController {
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
            self.locationManager.requestLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, self.regionRadius * 2.0, self.regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        self.searchButton.isHidden = true
    }
    
    func saveCurrentLocation() {
        // UserDefaults.standard.set(self.currentLocation, forKey: "LastUserLocation")
    }
}


// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
            self.locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
            
            if self.locationRequestedForNewPin {
                self.locationRequestedForNewPin = false
                self.completeNewPinCompose()
                
            } else {
                self.centerMapOnLocation(self.currentLocation!)
                if self.firstLoad {
                    self.currentHUD.hide(animated: true)
                    self.refreshData()
                }
            }
            
            print("Current location: \(location)")
            
        } else {
            // ...
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error finding location: \(error.localizedDescription)")
    }
}


// MARK: - Map View Delegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if !self.firstLoad {
            UIView.transition(with: self.searchButton, duration: 0.2, options: .transitionCrossDissolve, animations: { 
                self.searchButton.isHidden = false
            }, completion: nil)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Pin {
            let annotationView = MKAnnotationView()
            if let pinTypeString = (annotation as! Pin).pfObject["pinType"] as? String {
                if let pinType = PinType.PinType(rawValue: pinTypeString) {
                    annotationView.image = PinType.pinTypePinImage[pinType]
                }
            }
            annotationView.contentMode = .scaleAspectFit
            annotationView.bounds = CGRect(x: 0, y: 0, width: 32, height: 39)
            annotationView.canShowCallout = true
            
            let moreInfoButton = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = moreInfoButton
            
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // Assume control is pin detail disclosure.
        if let pinAnnotation = view.annotation as? Pin {
            if let pinTypeString = pinAnnotation.pfObject["pinType"] as? String {
                if let pinType = PinType.PinType(rawValue: pinTypeString) {
                    if pinType == .poiWiFi {
                        self.wiFiPinDetailView.pin = pinAnnotation.pfObject
                        self.showWiFiPinDetailView(true)
                    } else {
                        self.freedomBubblePinDetailView.pin = pinAnnotation.pfObject
                        self.showFreedomBubblePinDetailView(true)
                    }
                }
            }
        }
    }
}


// MARK: - Transition Helpers

extension MapViewController {
    fileprivate func showMenuView(_ show: Bool) {
        self.statusBarHidden = show
        self.setNeedsStatusBarAppearanceUpdate()
        self.showFullScreenView(view: self.menuView, show: show)
    }
    
    fileprivate func showNewPinTypeSelectionView(_ show: Bool) {
        self.statusBarHidden = show
        self.setNeedsStatusBarAppearanceUpdate()
        self.showFullScreenView(view: self.newPinTypeSelectionView, show: show)
    }
    
    fileprivate func showNewPinComposeView(_ show: Bool) {
        self.showFullScreenView(view: self.newPinComposeView, show: show)
    }
    
    fileprivate func showFreedomBubblePinDetailView(_ show: Bool) {
        self.showFullScreenView(view: self.freedomBubblePinDetailView, show: show)
    }
    
    fileprivate func showWiFiPinDetailView(_ show: Bool) {
        self.showFullScreenView(view: self.wiFiPinDetailView, show: show)
    }
    
    fileprivate func showFullScreenView(view: UIView, show: Bool) {
        if show {
            view.isHidden = false
            UIView.animate(withDuration: 0.15, delay: 0, options: .transitionCrossDissolve, animations: {
                view.alpha = 1
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.15, delay: 0, options: .transitionCrossDissolve, animations: {
                view.alpha = 0
            }) { _ in
                view.isHidden = true
            }
        }
    }
}


// MARK: - Menu View Delegate

extension MapViewController: MenuViewDelegate {
    func menuViewCloseButtonTapped() {
        self.showMenuView(false)
    }
}


// MARK: - New Pin Type Selection View Delegate

extension MapViewController: NewPinTypeSelectionViewDelegate {
    func newPinTypeSelectionViewCloseButtonTapped() {
        self.showNewPinTypeSelectionView(false)
    }
    
    func newPinTypeSelectionView(didSelectPinType pinType: PinType.PinType) {
        self.newPinComposeView.pinType = pinType
        self.showNewPinComposeView(true)
    }
}


// MARK: - New Pin Compose View Delegate

extension MapViewController: NewPinComposeViewDelegate {
    func newPinComposeViewCancelButtonTapped() {
        self.showNewPinComposeView(false)
    }
    
    func newPinComposeViewCameraButtonTapped() {
        self.present(self.chooseMediaAC, animated: true, completion: nil)
    }
    
    func newPinComposeView(didCreatePin pinWithoutLocation: PFObject) {
        self.newPin = pinWithoutLocation
        
        // TODO: Store image.
        // self.newPinPhotoImage =
        
        self.locationRequestedForNewPin = true
        self.locationManager.requestLocation()
    }
}


// MARK: - New Pin Compose Helpers

extension MapViewController {
    func completeNewPinCompose() {
        self.newPin["location"] = PFGeoPoint(location: self.currentLocation)
        self.newPin.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
                
                self.newPinComposeView.currentHUD.hide(animated: true)
                let ac = UIAlertController(title: "Upload Failed", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
                
            } else {
                
                print("NEW PIN UPLOAD SUCCESS")
                
                self.newPin = nil
                
                self.newPinComposeView.currentHUD.mode = MBProgressHUDMode.customView
                self.newPinComposeView.currentHUD.label.text = "Posted!"
                let delay: TimeInterval = 1.2
                self.newPinComposeView.currentHUD.hide(animated: true, afterDelay: delay)
                
                self.showNewPinComposeView(false)
                self.showNewPinTypeSelectionView(false)
                
                self.refreshData()      // TODO: Emphasize 'drop' of this individual pin.
            }
        }
    }
}


// MARK: - Pin Detail View Delegate

extension MapViewController: PinDetailViewDelegate {
    func pinDetailView(didFlag pin: PFObject) {
        PFUser.current()!.addUniqueObject(pin.objectId!, forKey: "flaggedByMe")
        PFUser.current()!.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                let ac = UIAlertController(title: "Post Flagged", message: "Administrators have been notified and this post will be reviewed.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            }
        }
        pin.addUniqueObject(PFUser.current()!, forKey: "flaggedBy")
        pin.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                print("ADDED FLAG TO PIN")
            }
        }
    }
    
    func pinDetailView(didRemoveFlag pin: PFObject) {
        PFUser.current()!.remove(pin.objectId!, forKey: "flaggedByMe")
        PFUser.current()!.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                let ac = UIAlertController(title: "Flag Removed", message: "Your flag has been removed from this post.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            }
        }
        pin.remove(PFUser.current()!, forKey: "flaggedBy")
        pin.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                print("REMOVED FLAG FROM PIN")
            }
        }
    }
}


// MARK: - Freedom Bubble Pin Detail View Delegate

extension MapViewController: FreedomBubblePinDetailViewDelegate {
    func freedomBubblePinDetailViewCloseButtonTapped() {
        self.showFreedomBubblePinDetailView(false)
    }
    
    func freedomBubblePinDetailView(didTapJoin pin: PFObject) {
        PFUser.current()!.addUniqueObject(pin.objectId!, forKey: "joinedByMe")
        PFUser.current()!.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                self.freedomBubblePinDetailView.currentHUD.mode = MBProgressHUDMode.customView
                self.freedomBubblePinDetailView.currentHUD.label.text = "Joined!"
                let delay: TimeInterval = 1.2
                self.freedomBubblePinDetailView.currentHUD.hide(animated: true, afterDelay: delay)
                
                self.freedomBubblePinDetailView.joinButton.isEnabled = false
                self.freedomBubblePinDetailView.pin = pin
            }
        }
        pin.addUniqueObject(PFUser.current()!, forKey: "joinedBy")
        pin.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                print("JOINED HUDDLE AT PIN")
            }
        }
    }
}


// MARK: - WiFi Pin Detail View Delegate

extension MapViewController: WiFiPinDetailViewDelegate {
    func wiFiPinDetailViewCloseButtonTapped() {
        self.showWiFiPinDetailView(false)
    }
    
    func wiFiPinDetailView(plusButtonTappedFor wiFiPin: PFObject) {
        PFUser.current()!.remove(wiFiPin.objectId!, forKey: "wiFiDownVotedByMe")
        PFUser.current()!.addUniqueObject(wiFiPin.objectId!, forKey: "wiFiUpVotedByMe")
        PFUser.current()!.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                self.wiFiPinDetailView.currentHUD.mode = MBProgressHUDMode.customView
                self.wiFiPinDetailView.currentHUD.label.text = "Wi-Fi Confirmed!"
                let delay: TimeInterval = 1.2
                self.wiFiPinDetailView.currentHUD.hide(animated: true, afterDelay: delay)
                
                self.wiFiPinDetailView.minusButton.isEnabled = true
                self.wiFiPinDetailView.plusButton.isEnabled = false
            }
        }
        wiFiPin.remove(PFUser.current()!, forKey: "wiFiDownVotedBy")
        wiFiPin.addUniqueObject(PFUser.current()!, forKey: "wiFiUpVotedBy")
        wiFiPin.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                print("WIFI UPVOTED AT WIFI PIN")
            }
        }
    }
    
    func wiFiPinDetailView(minusButtonTappedFor wiFiPin: PFObject) {
        PFUser.current()!.remove(wiFiPin.objectId!, forKey: "wiFiUpVotedByMe")
        PFUser.current()!.addUniqueObject(wiFiPin.objectId!, forKey: "wiFiDownVotedByMe")
        PFUser.current()!.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                self.wiFiPinDetailView.currentHUD.mode = MBProgressHUDMode.customView
                self.wiFiPinDetailView.currentHUD.label.text = "Wi-Fi Demoted"
                let delay: TimeInterval = 1.2
                self.wiFiPinDetailView.currentHUD.hide(animated: true, afterDelay: delay)
                
                self.wiFiPinDetailView.plusButton.isEnabled = true
                self.wiFiPinDetailView.minusButton.isEnabled = false
            }
        }
        wiFiPin.remove(PFUser.current()!, forKey: "wiFiUpVotedBy")
        wiFiPin.addUniqueObject(PFUser.current()!, forKey: "wiFiDownVotedBy")
        wiFiPin.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
            } else {
                print("WIFI DOWNVOTED AT WIFI PIN")
            }
        }
    }
}


// MARK: - Image Picker Controller Delegate

extension MapViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.newPinComposeView.pinPhotoImage = image
            self.newPinComposeView.pinPhotoImageView.image = image
            print("BANANANA")
        }
        self.newPinComposeView.addPhotoButton.alpha = 0
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Image Picker Controller Helpers

extension MapViewController {
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

extension MapViewController {
    @IBAction func onMenuButtonTapped(_ sender: Any) {
        self.showMenuView(true)
    }
    
    @IBAction func onPostButtonTapped(_ sender: Any) {
        if self.currentLocation != nil {
            self.centerMapOnLocation(self.currentLocation!)
        }
        self.showNewPinTypeSelectionView(true)
    }
    
    @IBAction func onCurrentLocationButtonTapped(_ sender: Any) {
        if self.currentLocation != nil {
            self.centerMapOnLocation(self.currentLocation!)
        }
    }
    
    @IBAction func onSearchButtonTapped(_ sender: Any) {
        self.searchButton.isHidden = true
        self.refreshData()
    }
}
