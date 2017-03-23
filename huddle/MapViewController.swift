//
//  MapViewController.swift
//  huddle
//
//  Created by Mateo Garcia on 3/19/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let METERS_PER_MILE = 1609.344

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
