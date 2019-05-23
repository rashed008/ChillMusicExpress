//
//  TrackManagedObjectModel.swift
//  MusicChill
//
//  Created by AAPBD on 2/7/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import Foundation
import CoreData

@objc(TrackManagedObjectModel)
class TrackManagedObjectModel: PlaylistManagedObjectBaseModel {

// Insert code here to add functionality to your managed object subclass

    func updateJsonModel(jModel: Track) {
        super.updateJsonModel(jModel)
    }
    
    func jsonModel()->Track {
        let jPlaylist = Track(JSON: ["k":"v"])!
        updateJsonModel(jPlaylist)
        return jPlaylist
    }
    
}
