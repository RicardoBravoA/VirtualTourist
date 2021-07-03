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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
    
    var data = [PhotoItemResponse]()
    
    lazy var selectBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
        return barButtonItem
      }()

      lazy var deleteBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
        return barButtonItem
      }()
    
    enum Mode {
        case view
        case select
    }
    
    var mode: Mode = .view {
        didSet {
            switch mode {
            case .view:
                for (key, value) in dictionarySelectedIndexPath {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
            
                dictionarySelectedIndexPath.removeAll()
            
                selectBarButton.title = "Select"
                navigationItem.leftBarButtonItem = nil
                collectionView.allowsMultipleSelection = false
            case .select:
                selectBarButton.title = "Cancel"
                navigationItem.leftBarButtonItem = deleteBarButton
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = selectBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigation.title = pin.pin.name
        
        setUpMap()
        
        ApiClient.searchPhotos(latitude: pin.pin.latitude, longitude: pin.pin.longitude) { response, error in
            self.data = response
            self.collectionView.reloadData()
        }
    }
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
        mode = mode == .view ? .select : .view
    }
      
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
        var deleteNeededIndexPaths: [IndexPath] = []
        for (key, value) in dictionarySelectedIndexPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
        
        for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
            data.remove(at: i.item)
        }
        
        collectionView.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndexPath.removeAll()
      }
    
}
