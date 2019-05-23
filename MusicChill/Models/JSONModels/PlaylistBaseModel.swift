//
//  PlaylistBaseModel.swift
//  MusicChill
//
//  Created by AAPBD on 2/10/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData
import SugarRecord

class PlaylistBaseModel: Mappable {
    
    var created_at: String?
    var id: Int = 0
    var release_day: String?
    var genre: String?
    var state: String?
    var download_count: Int = 0
    var license: String?
    var downloadable: Bool = false
    var duration: Int = 0
    var purchase_url: String?
    var descriptionTxt: String?//description
    var purchase_title: String?
    var embeddable_by: String?
    var tag_list: String?
    var track_type: String?
    var last_modified: String?
    var release_month: String?
    var original_format: String?
    var stream_url: String?
    var user: User?
    var bpm: String?
    var waveform_url: String?
    var label_name: String?
    var streamable: Bool = false
    var artwork_url: String?
    var attachments_uri: String?
    var comment_count: Int = 0
    var commentable: Bool = false
    var key_signature: String?
    var releaseTxt: String?//release
    var playback_count: Int = 0
    var kind: String?
    var user_id: Int = 0
    var isrc: String?
    var original_content_size: Int = 0
    var video_url: String?
    var release_year: String?
    var label_id: String?
    var uri: String?
    var title: String?
    var permalink_url: String?
    var favoritings_count: Int = 0
    var permalink: String?
    var sharing: String?
    
    convenience init() {
        self.init(JSON: [String:AnyObject]())!
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        
        created_at <- map["created_at"]
        id <- map["id"]
        release_day <- map["release_day"]
        genre <- map["genre"]
        license <- map["license"]
        downloadable <- map["downloadable"]
        duration <- map["duration"]
        purchase_url <- map["purchase_url"]
        descriptionTxt <- map["description"]
        purchase_title <- map["purchase_title"]
        release_month <- map["release_month"]
        tag_list <- map["tag_list"]
        last_modified <- map["last_modified"]
        embeddable_by <- map["embeddable_by"]
        user <- map["user"]
        label_name <- map["label_name"]
        artwork_url <- map["artwork_url"]
        streamable <- map["streamable"]
        releaseTxt <- map["release"]
        kind <- map["kind"]
        user_id <- map["user_id"]
        uri <- map["uri"]
        release_year <- map["release_year"]
        label_id <- map["label_id"]
        permalink_url <- map["permalink_url"]
        title <- map["title"]
        permalink <- map["permalink"]
        sharing <- map["sharing"]
        stream_url <- map["stream_url"]
    }
    
    func updateDataInManagedModel(managed:PlaylistManagedObjectBaseModel, context:Context) {
        managed.created_at = created_at
        managed.id = id
        managed.release_day = release_day
        managed.genre = genre
        managed.license = license
        managed.downloadable = downloadable
        managed.duration = duration
        managed.purchase_url = purchase_url
        managed.descriptionTxt = descriptionTxt
        managed.purchase_title = purchase_title
        managed.release_month = release_month
        managed.tag_list = tag_list
        managed.last_modified = last_modified
        managed.embeddable_by = embeddable_by
        managed.user = user?.managedModel(context)
        managed.label_name = label_name
        managed.artwork_url = artwork_url
        managed.streamable = streamable
        managed.kind = kind
        managed.user_id = user_id
        managed.uri = uri
        managed.release_year = release_year
        managed.label_id = label_id
        managed.permalink_url = permalink_url
        managed.title = title
        managed.permalink = permalink
        managed.sharing = sharing
        managed.stream_url = stream_url
    }
}