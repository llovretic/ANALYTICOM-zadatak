//
//  PlayerRegistraion.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import RealmSwift

class PlayerRegistrtion: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var dateFrom: Date = Date()
    @objc dynamic var dateTo: Date = Date()
    @objc dynamic var clubId: Int = 0
    @objc dynamic var playerId: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
