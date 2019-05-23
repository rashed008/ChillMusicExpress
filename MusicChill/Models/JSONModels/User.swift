//
//  User.swift
//  MusicChill
//
//  Created by AAPBD on 2/10/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData
import SugarRecord

class User: Mappable {
    
    var id: Int = 0
    var last_modified: String?
    var permalink_url: String?
    var username: String?
    var permalink: String?
    var kind: String?
    var uri: String?
    var avatar_url: String?
    
    convenience init() {
        self.init(JSON: [String:AnyObject]())!
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        last_modified <- map["last_modified"]
        permalink_url <- map["permalink_url"]
        permalink <- map["permalink"]
        kind <- map["kind"]
        avatar_url <- map["avatar_url"]
        username <- map["username"]
        uri <- map["uri"]
    }
    
    func updateDataInManagedModel(managed:UserManagedObjectModel, context:Context) {
        managed.id = id
        managed.last_modified = last_modified
        managed.permalink_url = permalink_url
        managed.permalink = permalink
        managed.kind = kind
        managed.avatar_url = avatar_url
        managed.username = username
        managed.uri = uri
    }
    
    func managedModel(context:Context)->UserManagedObjectModel {
        let managed:UserManagedObjectModel = try! context.new()
        updateDataInManagedModel(managed, context: context)
        return managed
    }
}