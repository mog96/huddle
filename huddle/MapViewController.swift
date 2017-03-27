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
    var menuView: MenuView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController {
    func showMenuView(show: Bool) {
        if show {
            self.menuView.isHidden = false
            self.statusBarHidden = true
            self.setNeedsStatusBarAppearanceUpdate()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.menuView.alpha = 1
            }, completion: nil)
            
        } else {
            self.statusBarHidden = false
            self.setNeedsStatusBarAppearanceUpdate()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.menuView.alpha = 0
            }) { _ in
                self.menuView.isHidden = true
            }
        }
    }
}

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


extension MapViewController: MenuViewDelegate {
    func menuViewCloseButtonTapped() {
        self.showMenuView(show: false)
    }
}


// MARK: - Actions

extension MapViewController {
    @IBAction func onMenuButtonTapped(_ sender: Any) {
        self.showMenuView(show: true)
    }
    
    @IBAction func onPostButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func onCurrentLocationButtonTapped(_ sender: Any) {
        
    }
}
