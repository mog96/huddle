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
import Parse
import PureLayout

class MapViewController: UIViewController {
    
    let METERS_PER_MILE = 1609.344

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    fileprivate var menuView: MenuView!
    fileprivate var newPinTypeSelectionView: NewPinTypeSelectionView!
    fileprivate var newPinComposeView: NewPinComposeView!
    
    fileprivate var statusBarHidden = false
    
    fileprivate var regionRadius: CLLocationDistance = 1000     // meters
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var currentLocation: CLLocation?
    
    fileprivate var locationRequestedForNewPin = false
    fileprivate var newPinType: PinType.PinType?
    fileprivate var newPinDescription: String?
    fileprivate var newPinImage: UIImage?
    
    fileprivate var currentHUD = MBProgressHUD()
    
    fileprivate var pins = [PFObject]()
    
    fileprivate var firstLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.menuView = Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)![0] as! MenuView
        self.view.addSubview(menuView)
        self.menuView.autoPinEdgesToSuperviewEdges()
        self.menuView.delegate = self
        self.menuView.alpha = 0
        self.menuView.isHidden = true
        
        self.newPinTypeSelectionView = Bundle.main.loadNibNamed("NewPinTypeSelectionView", owner: self, options: nil)![0] as! NewPinTypeSelectionView
        self.view.addSubview(newPinTypeSelectionView)
        self.newPinTypeSelectionView.autoPinEdgesToSuperviewEdges()
        self.newPinTypeSelectionView.delegate = self
        self.newPinTypeSelectionView.alpha = 0
        self.newPinTypeSelectionView.isHidden = true
        
        self.newPinComposeView = Bundle.main.loadNibNamed("NewPinComposeView", owner: self, options: nil)![0] as! NewPinComposeView
        self.view.addSubview(newPinComposeView)
        self.newPinComposeView.autoPinEdgesToSuperviewEdges()
        self.newPinComposeView.delegate = self
        self.newPinComposeView.alpha = 0
        self.newPinComposeView.isHidden = true
        
        self.mapView.delegate = self
        
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
        
        self.searchButton.isHidden = true
        
        // NotificationCenter.default.addObserver(self, selector: #selector(self.saveCurrentLocation), name: NSNotification.Name(rawValue: "UIApplicationDidEnterBackgroundNotification"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    func saveCurrentLocation() {
        UserDefaults.standard.set(self.currentLocation, forKey: "LastUserLocation")
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
            annotationView.image = #imageLiteral(resourceName: "art-pin")
            annotationView.contentMode = .scaleAspectFit
            annotationView.bounds = CGRect(x: 0, y: 0, width: 32, height: 39)
            annotationView.canShowCallout = true
            return annotationView
        }
        return nil
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
    
    func newPinComposeView(didPostPin pinType: PinType.PinType, withDescription description: String) {
        self.newPinType = pinType
        self.newPinDescription = description
        
        // TODO: Store image.
        
        self.locationRequestedForNewPin = true
        self.locationManager.requestLocation()
    }
}


// MARK: - New Pin Compose Helpers

extension MapViewController {
    func completeNewPinCompose() {
        
        let pin = PFObject(className: "Pin")
        pin["location"] = PFGeoPoint(location: self.currentLocation)
        pin["pinType"] = PinType.pinTypeString[self.newPinType!]
        pin["description"] = self.newPinDescription
        if let image = self.newPinImage {
            let imageData = UIImageJPEGRepresentation(image, 100)
            let imageFile = PFFile(name: "image.jpeg", data: imageData!)
            pin["imageFile"] = imageFile
        }
        pin["createdBy"] = PFUser.current()?.username
        pin.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print("Error: \(error!) \(error!.localizedDescription)")
                
                self.newPinComposeView.currentHUD.hide(animated: true)
                let ac = UIAlertController(title: "Upload Failed", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
                
            } else {
                
                print("NEW PIN UPLOAD SUCCESS")
                
                self.newPinType = nil
                self.newPinDescription = nil
                self.newPinImage = nil
                
                self.newPinComposeView.currentHUD.hide(animated: true)
                self.showNewPinComposeView(false)
                self.showNewPinTypeSelectionView(false)
                
                self.refreshData()      // TODO: Emphasize addition of this individual pin.
            }
        }
    }
}


// MARK: - Actions

extension MapViewController {
    @IBAction func onMenuButtonTapped(_ sender: Any) {
        self.showMenuView(true)
    }
    
    @IBAction func onPostButtonTapped(_ sender: Any) {
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
