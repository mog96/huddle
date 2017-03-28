//
//  Pin.swift
//  huddle
//
//  Created by Mateo Garcia on 3/27/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import MapKit
import Parse

class Pin: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let pfObject: PFObject
    
    init(object: PFObject) {
        let geoPoint = object["location"] as! PFGeoPoint
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(geoPoint.latitude), longitude: CLLocationDegrees(geoPoint.longitude))
        self.title = object["pinType"] as? String
        self.pfObject = object
        
        super.init()
    }
}
