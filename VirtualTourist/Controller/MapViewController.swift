//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 2/07/21.
//s

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.dataController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    @IBAction func longPressOnMap(_ sender: UILongPressGestureRecognizer) {
        let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
        savePoint(coordinate: coordinate)
    }
    
    func loadData() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        guard let data = try? dataController.fetchLocations() else { return }
        var annotations = [MKPointAnnotation]()
        
        for pin in data {
            let annotation = CustomPointAnnotation(pin: pin)
            annotations.append(annotation)
        }
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }

    }
    
    private func savePoint(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let annotation = MKPointAnnotation()
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            annotation.title = placemark.name ?? "Ubication not found"
            annotation.coordinate = coordinate
            
            let pin = Pin(context: self.dataController.viewContext)
            pin.longitude = annotation.coordinate.longitude
            pin.latitude = annotation.coordinate.latitude
            pin.name = annotation.title
            
            self.dataController.save()
            let pointAnnotation = CustomPointAnnotation(pin: pin)
            
            DispatchQueue.main.async {
                self.mapView.addAnnotation(pointAnnotation)
            }
        }
    }
    
}

extension MapViewController: MKMapViewDelegate, NSFetchedResultsControllerDelegate {
 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
        let pinAnnotation = annotation as! CustomPointAnnotation
        pinAnnotation.title = pinAnnotation.pin.name
   
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let mapRegion = [
            "latitude" : mapView.region.center.latitude,
            "longitude" : mapView.region.center.longitude,
            "latitudeDelta" : mapView.region.span.latitudeDelta,
            "longitudeDelta" : mapView.region.span.longitudeDelta
        ]
        UserDefaults.standard.set(mapRegion, forKey: "LastLocation")
    }
    
}
