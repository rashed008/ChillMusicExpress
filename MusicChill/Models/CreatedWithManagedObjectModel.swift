//
//  CreatedWithManagedObjectModel.swift
//  MusicChill
//
//  Created by AAPBD on 2/7/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import Foundation
import CoreData

@objc(CreatedWithManagedObjectModel)
class CreatedWithManagedObjectModel: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func updateJsonModel(jModel:Created_With) {
        jModel.id = id?.integerValue ?? 0
        jModel.external_url = external_url
        jModel.permalink_url = permalink_url
        jModel.kind = kind
        jModel.creator = creator
        jModel.name = name
        jModel.uri = uri
    }
    
    func jsonModel()->Created_With {
        let jPlaylist = Created_With(JSON: ["k":"v"])!
        updateJsonModel(jPlaylist)
        return jPlaylist
    }
    
}
