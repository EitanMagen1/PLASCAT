//
//  Event.swift
//  CoreDataMasterDetail
//
//  Created by Jason on 3/9/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import CoreData

class Search: NSManagedObject {

    @NSManaged var searchItem: String

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Search", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        searchItem = String()
    }
}
