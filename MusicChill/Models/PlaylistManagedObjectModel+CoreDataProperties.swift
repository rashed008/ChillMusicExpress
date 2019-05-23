//
//  PlaylistManagedObjectModel+CoreDataProperties.swift
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

extension PlaylistManagedObjectModel {

    @NSManaged var shuffleModeON: NSNumber?
    
    @NSManaged var ean: String?
    @NSManaged var playlist_type: String?
    @NSManaged var track_count: NSNumber?
    @NSManaged var type: String?
    @NSManaged var created_with: CreatedWithManagedObjectModel?
    @NSManaged var tracks: NSOrderedSet?

}
