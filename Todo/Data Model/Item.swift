//
//  Item.swift
//  Todo
//
//  Created by Adhoom ahmed on 1/19/18.
//  Copyright © 2018 Adhoom ahmed. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  @objc dynamic var title:String = ""
   @objc dynamic var done:Bool = false
    @objc dynamic var dataCearted: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

