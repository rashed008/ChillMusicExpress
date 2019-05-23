//
//  PlaylistManagedObjectBaseModel+CoreDataProperties.swift
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

extension PlaylistManagedObjectBaseModel {

    @NSManaged var artwork_url: String?
    @NSManaged var attachments_uri: String?
    @NSManaged var bpm: String?
    @NSManaged var comment_count: NSNumber?
    @NSManaged var commentable: NSNumber?
    @NSManaged var created_at: String?
    @NSManaged var descriptionTxt: String?
    @NSManaged var download_count: NSNumber?
    @NSManaged var downloadable: NSNumber?
    @NSManaged var duration: NSNumber?
    @NSManaged var embeddable_by: String?
    @NSManaged var favoritings_count: NSNumber?
    @NSManaged var genre: String?
    @NSManaged var id: NSNumber?
    @NSManaged var isrc: String?
    @NSManaged var key_signature: String?
    @NSManaged var kind: String?
    @NSManaged var label_id: String?
    @NSManaged var label_name: String?
    @NSManaged var last_modified: String?
    @NSManaged var license: String?
    @NSManaged var original_content_size: String?
    @NSManaged var original_format: String?
    @NSManaged var permalink: String?
    @NSManaged var permalink_url: String?
    @NSManaged var playback_count: NSNumber?
    @NSManaged var purchase_title: String?
    @NSManaged var purchase_url: String?
    @NSManaged var release_day: String?
    @NSManaged var release_month: String?
    @NSManaged var release_year: String?
    @NSManaged var releaseTxt: String?
    @NSManaged var sharing: String?
    @NSManaged var state: String?
    @NSManaged var stream_url: String?
    @NSManaged var streamable: NSNumber?
    @NSManaged var tag_list: String?
    @NSManaged var title: String?
    @NSManaged var track_type: String?
    @NSManaged var uri: String?
    @NSManaged var user_id: NSNumber?
    @NSManaged var video_url: String?
    @NSManaged var waveform_url: String?
    @NSManaged var user: UserManagedObjectModel?

}
