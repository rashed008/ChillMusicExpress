//
//  Track.swift
//  MusicChill
//
//  Created by AAPBD on 2/10/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData
import SugarRecord

class Track: PlaylistBaseModel {
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
    }
    
    func updateDataInManagedModel(managed:TrackManagedObjectModel, context: Context) {
        super.updateDataInManagedModel(managed, context: context)
    }
    
    func managedModel(context:Context)->TrackManagedObjectModel {
        let managed:TrackManagedObjectModel = try! context.new()
        updateDataInManagedModel(managed, context: context)
        return managed
    }
    
}
