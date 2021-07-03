//
//  PhotoViewController+CollectionView.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 3/07/21.
//

import Foundation
import UIKit

extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewCell", for: indexPath) as! PhotoViewCell
        
        guard (fetchedResultsController.fetchedObjects?.isEmpty == false) else {
            print("Images in CoreData")
            return cell
        }
        
        let photo = fetchedResultsController.object(at: indexPath)
        
        if photo.imageData == nil {
            ApiClient.image(url: photo.imageUrl!.absoluteString) { data, error in
                guard let data = data else { return }
                photo.imageData = data
                self.dataController.save()
                cell.photoImageView.image = UIImage(data: data)
            }
        } else {
            if let imageData = photo.imageData {
                let image = UIImage(data: imageData)
                cell.photoImageView.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space:CGFloat = 5.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        let size = CGSize(width: dimension, height: dimension)
        flowLayout.itemSize = size
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mode == .select {
            dictionarySelectedIndexPath[indexPath] = false
        }
    }
    
}
