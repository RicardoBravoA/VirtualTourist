//
//  PhotoViewController.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 3/07/21.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    var pin: CustomPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Pin \(pin)")
    }
    
}
