//
//  UserManagedObjectModel+CoreDataProperties.swift
//  MusicChill
//
//  Created by AAPBD on 2/9/16.
//  Copyright © 2016 Hemal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserManagedObjectModel {

    @NSManaged var avatar_url: String?
    @NSManaged var id: NSNumber?
    @NSManaged var kind: String?
    @NSManaged var last_modified: String?
    @NSManaged var permalink: String?
    @NSManaged var permalink_url: String?
    @NSManaged var uri: String?
    @NSManaged var username: String?

}
