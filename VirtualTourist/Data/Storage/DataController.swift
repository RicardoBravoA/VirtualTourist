//
//  DataController.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 2/07/21.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    static let shared = DataController(modelName: "VirtualTourist")
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContext() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContext()
            completion?()
        }
    }
    
    func save() throws {
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
    
}

extension DataController {
    func autoSaveViewContext(interval:TimeInterval = 30) {
        
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        try? save()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
