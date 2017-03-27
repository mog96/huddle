//
//  MapViewController.swift
//  huddle
//
//  Created by Mateo Garcia on 3/19/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import MapKit
import PureLayout

class MapViewController: UIViewController {
    
    let METERS_PER_MILE = 1609.344

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    var menuView: MenuView!
    var newPinTypeSelectionView: NewPinTypeSelectionView!
    var newPinComposeView: NewPinComposeView!
    
    var statusBarHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var zoomLocation = CLLocationCoordinate2D()
        zoomLocation.latitude = 37.769319
        zoomLocation.longitude = -122.487104
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE)
        self.mapView.setRegion(viewRegion, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let annotation = MKPointAnnotation()
        let coord = self.mapView.centerCoordinate
        annotation.coordinate = coord
        annotation.title = "art"
        self.mapView.addAnnotation(annotation)
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
}


// MARK: - Helpers

extension MapViewController {
    fileprivate func showMenuView(_ show: Bool) {
        self.showFullScreenView(view: self.menuView, show: show)
    }
    
    fileprivate func showNewPinTypeSelectionView(_ show: Bool) {
        self.showFullScreenView(view: self.newPinTypeSelectionView, show: show)
    }
    
    fileprivate func showNewPinComposeView(_ show: Bool) {
        self.showFullScreenView(view: self.newPinComposeView, show: show)
    }
    
    fileprivate func showFullScreenView(view: UIView, show: Bool) {
        if show {
            view.isHidden = false
            self.statusBarHidden = true
            self.setNeedsStatusBarAppearanceUpdate()
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                view.alpha = 1
            }, completion: nil)
            
        } else {
            self.statusBarHidden = false
            self.setNeedsStatusBarAppearanceUpdate()
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
                view.alpha = 0
            }) { _ in
                view.isHidden = true
            }
        }
    }
}


// MARK: - Map View Delegate

extension MapViewController: MKMapViewDelegate {
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = MKAnnotationView()
        annotation.image = #imageLiteral(resourceName: "art-pin")
        
        // TODO: CONSTRAIN IMAGE
        
        return annotation
    }
    */
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
        //
    }
}
