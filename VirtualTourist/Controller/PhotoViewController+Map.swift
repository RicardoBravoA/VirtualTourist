//
//  PhotoViewController+Map.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 3/07/21.
//

import Foundation
import MapKit

extension PhotoViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
         
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func setUpMap() {
        guard let pin = pin else {
            return
        }
        
        DispatchQueue.main.async {
            self.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: pin.pin.latitude, longitude: pin.pin.longitude)
            self.mapView.addAnnotation(pin)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            self.mapView.selectAnnotation(pin, animated: true)
        }
    }
    
}
