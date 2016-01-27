//
//  NoteEntity+CoreDataProperties.swift
//  ChowNote
//
//  Created by Jason Chan MBP on 1/26/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension NoteEntity {

    @NSManaged var body: String?
    @NSManaged var date: NSDate?
    @NSManaged var title: String?

}
