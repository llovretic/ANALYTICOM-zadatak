//
//  Player.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import RealmSwift

class Player: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var dateOfBirth: Date = Date()
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var placeOfBirth: String = ""
    @objc dynamic var uniqueID: String = ""
    @objc dynamic var countryId: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
