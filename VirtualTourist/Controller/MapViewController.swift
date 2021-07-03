//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 2/07/21.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    private var lastLocation = "LastLocation"
    var pin: CustomPointAnnotation?
    
    var dataController: DataController! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.dataController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLastRegionVisible()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    @IBAction func longPressOnMap(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            savePoint(coordinate: coordinate)
        }
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
            self.performSegue(withIdentifier: "photoSegue", sender: pointAnnotation)
        }
    }
    
    func showLastRegionVisible() {
        if let mapRegin = UserDefaults.standard.dictionary(forKey: lastLocation) {
            let location = mapRegin as! [String: CLLocationDegrees]
            let center = CLLocationCoordinate2D(latitude: location["latitude"]!, longitude: location["longitude"]!)
            let span = MKCoordinateSpan(latitudeDelta: location["latitudeDelta"]!, longitudeDelta: location["longitudeDelta"]!)
            
            DispatchQueue.main.async {
                self.mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSegue" {
            guard let navigationController = segue.destination as? UINavigationController else {
                return
            }
            
            guard let photoViewController = navigationController.topViewController as? PhotoViewController else {
                return
            }
            let pin: CustomPointAnnotation = sender as! CustomPointAnnotation
            photoViewController.pin = pin
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
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        pin = pinAnnotation
        
        return pinView
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let mapRegion = [
            "latitude" : mapView.region.center.latitude,
            "longitude" : mapView.region.center.longitude,
            "latitudeDelta" : mapView.region.span.latitudeDelta,
            "longitudeDelta" : mapView.region.span.longitudeDelta
        ]
        UserDefaults.standard.set(mapRegion, forKey: lastLocation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "photoSegue", sender: pin)
        }
    }
    
}
