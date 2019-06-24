//
//  Club.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import RealmSwift

class Clubs: Object{
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
