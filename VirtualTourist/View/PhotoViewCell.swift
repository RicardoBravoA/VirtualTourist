//
//  PhotoViewCell.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 3/07/21.
//

import Foundation
import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var highlightIndicator: UIView!
    @IBOutlet weak var selectIndicator: UIImageView!
    
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
      
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
            selectIndicator.isHidden = !isSelected
        }
    }
    
}
