//
//  PersistenceController.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 26.12.25.
//

import CoreData
import CoreData

final class PersistenceController {

    static let shared = PersistenceController()
    let container: NSPersistentContainer

    private init() {

        container = NSPersistentContainer(name: "CoreData")

        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber,
                               forKey: NSMigratePersistentStoresAutomaticallyOption)
        description?.setOption(true as NSNumber,
                               forKey: NSInferMappingModelAutomaticallyOption)

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load error: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
