//
//  Created_With.swift
//  MusicChill
//
//  Created by AAPBD on 2/10/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData
import SugarRecord

class Created_With: Mappable {
    
    var id: Int = 0
    var external_url: String?
    var permalink_url: String?
    var kind: String?
    var creator: String?
    var name: String?
    var uri: String?
    
    convenience init() {
        self.init(JSON: [String:AnyObject]())!
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        external_url <- map["external_url"]
        permalink_url <- map["permalink_url"]
        kind <- map["kind"]
        creator <- map["creator"]
        name <- map["name"]
        uri <- map["uri"]
    }
    
    func updateDataInManagedModel(managed:CreatedWithManagedObjectModel, context:Context) {
        managed.id = id
        managed.external_url = external_url
        managed.permalink_url = permalink_url
        managed.kind = kind
        managed.creator = creator
        managed.name = name
        managed.uri = uri
    }
    
    func managedModel(context:Context)->CreatedWithManagedObjectModel {
        let managed:CreatedWithManagedObjectModel = try! context.new()
        updateDataInManagedModel(managed, context: context)
        return managed
    }
}