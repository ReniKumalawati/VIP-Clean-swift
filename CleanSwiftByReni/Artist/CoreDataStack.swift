//
//  CoreDataStack.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 20/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    private init(){}
    static let shared = CoreDataStack()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StarWars")
        container.loadPersistentStores(completionHandler: {(_, error) in
            guard let error = error as NSError? else {return}
            fatalError("unresolved errpr: \(error), \(error.userInfo)")
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
}
