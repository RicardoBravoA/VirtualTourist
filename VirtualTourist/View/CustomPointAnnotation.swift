//
//  PointAnnotation.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 2/07/21.
//

import Foundation
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    
    var pin: Pin
    
    init(pin: Pin) {
        
        self.pin = pin
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        self.title = pin.name
    }
    
}
