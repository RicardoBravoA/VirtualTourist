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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Pin \(pin)")
    }
    
    @IBAction func deletePhoto(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
    }
}
