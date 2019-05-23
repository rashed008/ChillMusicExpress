//
//  PlaylistManagedObjectBaseModel.swift
//  MusicChill
//
//  Created by AAPBD on 2/7/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import Foundation
import CoreData


class PlaylistManagedObjectBaseModel: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func updateJsonModel(jModel:PlaylistBaseModel) {
        jModel.created_at = created_at
        jModel.id = id?.integerValue ?? 0
        jModel.release_day = release_day
        jModel.genre = genre
        jModel.license = license
        jModel.downloadable = downloadable?.boolValue ?? false
        jModel.duration = duration?.integerValue ?? 0
        jModel.purchase_url = purchase_url
        jModel.descriptionTxt = descriptionTxt
        jModel.purchase_title = purchase_title
        jModel.release_month = release_month
        jModel.tag_list = tag_list
        jModel.last_modified = last_modified
        jModel.embeddable_by = embeddable_by
        jModel.user = user?.jsonModel()
        jModel.label_name = label_name
        jModel.artwork_url = artwork_url
        jModel.streamable = streamable?.boolValue ?? false
        jModel.kind = kind
        jModel.user_id = user_id?.integerValue ?? 0
        jModel.uri = uri
        jModel.release_year = release_year
        jModel.label_id = label_id
        jModel.permalink_url = permalink_url
        jModel.title = title
        jModel.permalink = permalink
        jModel.sharing = sharing
        jModel.stream_url = stream_url
    }

}
