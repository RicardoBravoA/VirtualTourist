//
//  Photo+Extension.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 2/07/21.
//

import Foundation

extension Photo {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        created = Date()
    }
    
}
