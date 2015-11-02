//
//  Note.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/2.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import RealmSwift

class Note: Object {
    dynamic var name = ""
    dynamic var createdAt = ""
    dynamic var note = ""
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
