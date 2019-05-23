//
//  PlaylistModel.swift
//  MusicChill
//
//  Created by AAPBD on 2/2/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreData
import SugarRecord

class PlaylistModel: PlaylistBaseModel {

    var shuffleModeON: Int = 0
    
    var track_count: Int = 0
    var ean: String?
    var type: String?
    var playlist_type: String?
    var tracks: [Track]?
    var created_with: Created_With?
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        
        shuffleModeON <- map["shuffleModeON"]
        
        track_count <- map["track_count"]
        ean <- map["ean"]
        type <- map["type"]
        playlist_type <- map["playlist_type"]
        tracks <- map["tracks"]
        created_with <- map["created_with"]
    }
    
    func updateDataInManagedModel(managed:PlaylistManagedObjectModel, context:Context) {
        super.updateDataInManagedModel(managed, context: context)
        
        managed.shuffleModeON = shuffleModeON
        
        managed.track_count = track_count
        managed.ean = type
        managed.playlist_type = playlist_type
        if let tracks = tracks {
            let arr = tracks.map({ return $0.managedModel(context) })
            managed.tracks = NSOrderedSet(array: arr)
        }
        managed.created_with = created_with?.managedModel(context)
    }
    
    func managedModel(context:Context)->PlaylistManagedObjectModel {
        let managed:PlaylistManagedObjectModel = try! context.new()
        updateDataInManagedModel(managed, context: context)
        return managed
    }

}
