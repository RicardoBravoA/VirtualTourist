//
//  PhotoViewController.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 3/07/21.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var navigation: UINavigationItem!
    var pin: CustomPointAnnotation!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
    @IBOutlet weak var noImagesLabel: UILabel!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    var dataController: DataController! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.dataController
    }
    
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
        
        setUpFetchedResultsController()
        navigation.title = pin.pin.name
        
        setUpMap()
        loadPhotos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
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
    
    @IBAction func loadPhotos(_ sender: UIButton) {
        loadPhotos()
    }
    
    private func loadPhotos(){
        activityIndicator.startAnimating()
        buttonEnabled(false, button: newCollectionButton)
        
        if !data.isEmpty {
            data = []
            collectionView.reloadData()
        }
    
        print("CoreData images: \(fetchedResultsController.fetchedObjects?.isEmpty)")
        
        guard (fetchedResultsController.fetchedObjects?.isEmpty == true) else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            print("CoreData images exists")
            return
        }
        
        print("No images, reload")
        
        ApiClient.searchPhotos(latitude: pin.pin.latitude, longitude: pin.pin.longitude) { response, error in
            if error != nil {
                self.showAlertController(message: error?.localizedDescription ?? "Error")
            } else {
                if response.isEmpty {
                    self.noImagesLabel.isHidden = false
                } else {
                    for item in response {
                        let photo = Photo(context: self.dataController.viewContext)
                        photo.imageUrl = URL(string: item.url)
                        photo.imageData = nil
                        photo.pin = self.pin.pin
                        photo.id = item.id
                        
                        self.dataController.save()
                    }
                    
                    self.noImagesLabel.isHidden = true
                    self.data = response
                    self.collectionView.reloadData()
                }
            }
            
            self.activityIndicator.stopAnimating()
            self.buttonEnabled(true, button: self.newCollectionButton)
        }
    }
    
    private func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
       
        if let pin = pin {
            let predicate = NSPredicate(format: "pin == %@", pin.pin)
            fetchRequest.predicate = predicate
         
            print("\(pin.pin.latitude) \(pin.pin.longitude)")
        }
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: dataController.viewContext,
                                                              sectionNameKeyPath: nil, cacheName: "photo")
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}
