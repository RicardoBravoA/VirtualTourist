//
//  EndPoint.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 2/07/21.
//

import Foundation

enum EndPoint {
    static let apiKey = "c16d6433413442d5dc85a8928d901540"
    static let urlBase = "https://www.flickr.com/services/rest/"
    
    case photoSearch(Double, Double, Int)
    case image(String)
    
    var value: String {
        switch self {
        case .photoSearch(let latitude, let longitude, let page):
            return EndPoint.urlBase
                + "?method=flickr.photos.search"
                + "&api_key=\(EndPoint.apiKey)" +
                "&lat=\(latitude)" +
                "&lon=\(longitude)" +
                "&radius=20" +
                "&per_page=20" +
                "&page=\(page)" +
            "&format=json&nojsoncallback=1&extras=url_m"
        case .image(let url):
            return url
        }
    }
    
    var url: URL {
        return URL(string: value)!
    }
}
