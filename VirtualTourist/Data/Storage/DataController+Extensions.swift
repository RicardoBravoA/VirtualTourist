//
//  DataController+Extensions.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 2/07/21.
//

import Foundation
import CoreData

extension DataController {
    func fetchLastLocation(_ predicate: NSPredicate, sorting: NSSortDescriptor? = nil) throws -> Pin? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fetchRequest.predicate = predicate
        
        if let sorting = sorting {
            fetchRequest.sortDescriptors = [sorting]
        }
        guard let location = (try viewContext.fetch(fetchRequest) as! [Pin]).first else {
            return nil
        }
        return location
    }
    
    func fetchLocations() throws -> [Pin]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        guard let pin = try viewContext.fetch(fetchRequest) as? [Pin] else {
            return nil
        }
        return pin
    }
    
    func fetchPhotos(_ predicate: NSPredicate? = nil, sorting: NSSortDescriptor? = nil) throws -> [Photo]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = predicate
        
        if let sorting = sorting {
            fetchRequest.sortDescriptors = [sorting]
        }
        guard let allPhoto = try viewContext.fetch(fetchRequest) as? [Photo] else {
            return nil
        }
        return allPhoto
    }
}
