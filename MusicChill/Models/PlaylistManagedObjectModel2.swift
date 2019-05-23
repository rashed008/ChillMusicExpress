//
//  PlaylistManagedObjectModel.swift
//  MusicChill
//
//  Created by AAPBD on 2/7/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import UIKit
import CoreData

class PlaylistManagedObjectModel: NSManagedObject {
    
    @NSManaged var track_count: Int
    @NSManaged var ean: String?
    @NSManaged var type: String?
    @NSManaged var playlist_type: String?
    @NSManaged var tracks: [TrackManagedObjectModel]?
    @NSManaged var created_with: CreatedWithManagedObjectModel?
    
//    init(jsonModel:PlaylistModel) {
//        track_count = jsonModel.track_count
//        ean = jsonModel.ean
//        type = jsonModel.type
//        playlist_type = jsonModel.playlist_type
//        
//        tracks = jsonModel.tracks!.map { return TrackManagedObjectModel(jsonModel: $0) }
//        
//        created_with = jsonModel.created_with.map { return CreatedWithManagedObjectModel(jsonModel: $0) }
//    }
}

class TrackManagedObjectModel: PlaylistManagedObjectBaseModel {
    
    
}

class UserManagedObjectModel: NSManagedObject {
    
    @NSManaged var id: Int
    @NSManaged var last_modified: String?
    @NSManaged var permalink_url: String?
    @NSManaged var username: String?
    @NSManaged var permalink: String?
    @NSManaged var kind: String?
    @NSManaged var uri: String?
    @NSManaged var avatar_url: String?
    
    class func mapUserManagedObjectModelWithUser(user user: User) {
        
    }
    
//    init(jsonModel:User) {
//        
//        id = jsonModel.id
//        last_modified = jsonModel.last_modified
//        permalink_url = jsonModel.permalink_url
//        username = jsonModel.username
//        permalink = jsonModel.permalink
//        kind = jsonModel.kind
//        uri = jsonModel.uri
//        avatar_url = jsonModel.avatar_url
//    }
}

class CreatedWithManagedObjectModel: NSManagedObject {
    
    @NSManaged var id: Int
    @NSManaged var external_url: String?
    @NSManaged var permalink_url: String?
    @NSManaged var kind: String?
    @NSManaged var creator: String?
    @NSManaged var name: String?
    @NSManaged var uri: String?
    
//    init(jsonModel:Created_With) {
//        id = jsonModel.id
//        external_url = jsonModel.external_url
//        permalink_url = jsonModel.permalink_url
//        kind = jsonModel.kind
//        creator = jsonModel.creator
//        name = jsonModel.name
//        uri = jsonModel.uri
//    }
}

class PlaylistManagedObjectBaseModel: NSManagedObject {
    
    @NSManaged var created_at: String?
    @NSManaged var id: Int
    @NSManaged var release_day: String?
    @NSManaged var genre: String?
    @NSManaged var state: String?
    @NSManaged var download_count: Int
    @NSManaged var license: String?
    @NSManaged var downloadable: Bool
    @NSManaged var duration: Int
    @NSManaged var purchase_url: String?
    @NSManaged var descriptionTxt: String?//description
    @NSManaged var purchase_title: String?
    @NSManaged var embeddable_by: String?
    @NSManaged var tag_list: String?
    @NSManaged var track_type: String?
    @NSManaged var last_modified: String?
    @NSManaged var release_month: String?
    @NSManaged var original_format: String?
    @NSManaged var stream_url: String?
    @NSManaged var user: UserManagedObjectModel?
    @NSManaged var bpm: String?
    @NSManaged var waveform_url: String?
    @NSManaged var label_name: String?
    @NSManaged var streamable: Bool
    @NSManaged var artwork_url: String?
    @NSManaged var attachments_uri: String?
    @NSManaged var comment_count: Int
    @NSManaged var commentable: Bool
    @NSManaged var key_signature: String?
    @NSManaged var releaseTxt: String?//release
    @NSManaged var playback_count: Int
    @NSManaged var kind: String?
    @NSManaged var user_id: Int
    @NSManaged var isrc: String?
    @NSManaged var original_content_size: Int
    @NSManaged var video_url: String?
    @NSManaged var release_year: String?
    @NSManaged var label_id: String?
    @NSManaged var uri: String?
    @NSManaged var title: String?
    @NSManaged var permalink_url: String?
    @NSManaged var favoritings_count: Int
    @NSManaged var permalink: String?
    @NSManaged var sharing: String?
    
//    init(jsonModel:PlaylistBaseModel) {
//        
//        created_at = jsonModel.created_at
//        id = jsonModel.id
//        genre = jsonModel.genre
//        state = jsonModel.state
//        download_count = jsonModel.download_count
//        license = jsonModel.license
//        downloadable = jsonModel.downloadable
//        
//        duration = jsonModel.duration
//        purchase_url = jsonModel.purchase_url
//        descriptionTxt = jsonModel.descriptionTxt
//        purchase_title = jsonModel.purchase_title
//        embeddable_by = jsonModel.embeddable_by
//        tag_list = jsonModel.tag_list
//        track_type = jsonModel.track_type
//        
//        last_modified = jsonModel.last_modified
//        release_month = jsonModel.release_month
//        original_format = jsonModel.original_format
//        stream_url = jsonModel.stream_url
//        embeddable_by = jsonModel.embeddable_by
//        //user = jsonModel.user
//        bpm = jsonModel.bpm
//        
//        waveform_url = jsonModel.waveform_url
//        label_name = jsonModel.label_name
//        streamable = jsonModel.streamable
//        artwork_url = jsonModel.artwork_url
//        embeddable_by = jsonModel.embeddable_by
//        attachments_uri = jsonModel.attachments_uri
//        comment_count = jsonModel.comment_count
//        
//        commentable = jsonModel.commentable
//        key_signature = jsonModel.key_signature
//        
//        releaseTxt = jsonModel.releaseTxt
//        playback_count = jsonModel.playback_count
//        kind = jsonModel.kind
//        user_id = jsonModel.user_id
//        isrc = jsonModel.isrc
//        original_content_size = jsonModel.original_content_size
//        
//        video_url = jsonModel.video_url
//        release_year = jsonModel.release_year
//        label_id = jsonModel.label_id
//        uri = jsonModel.uri
//        isrc = jsonModel.isrc
//        title = jsonModel.title
//        
//        permalink_url = jsonModel.permalink_url
//        favoritings_count = jsonModel.favoritings_count
//        permalink = jsonModel.permalink
//        sharing = jsonModel.sharing
//    }
}
