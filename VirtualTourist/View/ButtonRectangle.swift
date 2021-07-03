//
//  ButtonRectangle.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 3/07/21.
//

import UIKit

class RectangleButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.systemBlue
    }
    
}
