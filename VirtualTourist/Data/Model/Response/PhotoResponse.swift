//
//  PhotoResponse.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 2/07/21.
//

import Foundation

struct PhotoResponse: Codable {
    let photo: [PhotoItemResponse]
}

struct PhotoItemResponse: Codable {
    let id: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "url_m"
    }
}
