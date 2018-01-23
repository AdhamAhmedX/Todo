//
//  Category.swift
//  Todo
//
//  Created by Adhoom ahmed on 1/19/18.
//  Copyright © 2018 Adhoom ahmed. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var titlee:String = ""
    let items = List<Item>()
}
