//
//  ApiClient.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 2/07/21.
//

import Foundation

class ApiClient {
    
    class func searchPhotos(latitude: Double, longitude: Double, completion: @escaping ([PhotoItemResponse], Error?) -> Void) {
        print(EndPoint.photoSearch(latitude, longitude).url)
        taskForGETRequest(url: EndPoint.photoSearch(latitude, longitude).url, response: PhotoResponse.self) { response, error in
            if let response = response {
                completion(response.photos.photo , nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func image(url: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoint.image(url).url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        task.resume()
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
}
