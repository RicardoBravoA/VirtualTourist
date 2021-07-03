//
//  PhotoViewController.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 3/07/21.
//

import Foundation
import UIKit
import MapKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var navigation: UINavigationItem!
    var pin: CustomPointAnnotation!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigation.title = pin.pin.name
        
        setUpMap()
        
        ApiClient.searchPhotos(latitude: pin.pin.latitude, longitude: pin.pin.longitude) { response, error in
            print(response)
            print(error)
        }
    }
    
    @IBAction func deletePhoto(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
    }
}
