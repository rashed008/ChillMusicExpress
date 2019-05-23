//
//  UserManagedObjectModel.swift
//  MusicChill
//
//  Created by AAPBD on 2/7/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import Foundation
import CoreData

@objc(UserManagedObjectModel)
class UserManagedObjectModel: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func updateJsonModel(jModel:User) {
        jModel.id = id?.integerValue ?? 0
        jModel.last_modified = last_modified
        jModel.permalink_url = permalink_url
        jModel.permalink = permalink
        jModel.kind = kind
        jModel.avatar_url = avatar_url
        jModel.username = username
        jModel.uri = uri
    }
    
    func jsonModel()->User {
        let jPlaylist = User(JSON: ["k":"v"])!
        updateJsonModel(jPlaylist)
        return jPlaylist
    }

}
