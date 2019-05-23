//
//  PlaylistManagedObjectModel.swift
//  MusicChill
//
//  Created by AAPBD on 2/7/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import Foundation
import CoreData

@objc(PlaylistManagedObjectModel)
class PlaylistManagedObjectModel: PlaylistManagedObjectBaseModel {

// Insert code here to add functionality to your managed object subclass
    
    func updateJsonModel(jModel:PlaylistModel) {
        
        jModel.shuffleModeON = shuffleModeON?.integerValue ?? 0
        
        jModel.track_count = track_count?.integerValue ?? 0
        jModel.ean = type
        jModel.playlist_type = playlist_type
        if let tracks = tracks?.array as? [TrackManagedObjectModel] {
            jModel.tracks = tracks.map({ return $0.jsonModel() })
        }
        jModel.created_with = created_with?.jsonModel()
    }
    
    func jsonModel()->PlaylistModel {
        let jPlaylist = PlaylistModel(JSON: ["k":"v"])!
        updateJsonModel(jPlaylist)
        return jPlaylist
    }
}
